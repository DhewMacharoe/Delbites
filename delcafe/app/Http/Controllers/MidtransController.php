<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Midtrans\Config;
use Midtrans\Snap;
use Midtrans\Transaction;
use App\Models\Pemesanan;

class MidtransController extends Controller
{
    public function __construct()
    {
        // Set your Midtrans server key
        Config::$serverKey = env('MIDTRANS_SERVER_KEY');
        // Set to Development/Sandbox Environment (default). Set to true for Production Environment (accept real transaction).
        Config::$isProduction = env('MIDTRANS_IS_PRODUCTION', false);
        // Set sanitization on (default)
        Config::$isSanitized = true;
        // Set 3DS transaction for credit card to true
        Config::$is3ds = true;
    }

    public function createTransaction(Request $request)
    {
        
        $request->validate([
            'id_pelanggan' => 'required|integer|exists:pelanggan,id', // <-- pastikan dikirim dan valid
            'order_id' => 'required|string',
            'gross_amount' => 'required|numeric',
            'first_name' => 'required|string',
            'last_name' => 'nullable|string',
            'email' => 'required|email',
            'items' => 'required|array',
            'items.*.id' => 'required|string',
            'items.*.name' => 'required|string',
            'items.*.price' => 'required|numeric',
            'items.*.quantity' => 'required|numeric',
        ]);

        // Buat entri pemesanan terlebih dahulu
        $pemesanan = Pemesanan::create([
            'id_pelanggan' => $request->id_pelanggan,
            'admin_id' => null,
            'total_harga' => $request->gross_amount,
            'metode_pembayaran' => 'midtrans',
            'bukti_pembayaran' => null,
            'status' => 'pembayaran',
            'waktu_pemesanan' => now(),
            'waktu_pengambilan' => null,
        ]);

        // Buat order ID berbasis id pemesanan
        $orderId = 'ORDER-' . $pemesanan->id . '-' . time();

        // Simpan order ID ke kolom bukti_pembayaran
        $pemesanan->bukti_pembayaran = $orderId;
        $pemesanan->save();

        // Persiapkan parameter untuk Midtrans
        $params = [
            'transaction_details' => [
                'order_id' => $orderId,
                'gross_amount' => $request->gross_amount,
            ],
            'customer_details' => [
                'first_name' => $request->first_name,
                'last_name' => $request->last_name,
                'email' => $request->email,
            ],
            'item_details' => $request->items,
            'expiry' => [
                'start_time' => now()->format('Y-m-d H:i:s O'),
                'unit' => 'minute',
                'duration' => 15
            ],
            'enabled_payments' => ['gopay', 'echannel'] // VA Mandiri = echannel
        ];

        try {
            $snapToken = Snap::getSnapToken($params);
            $redirectUrl = Snap::getSnapUrl($params);

            return response()->json([
                'status' => 'success',
                'snap_token' => $snapToken,
                'redirect_url' => $redirectUrl,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
            ], 500);
        }
    }


    public function checkStatus($orderId)
    {
        try {
            $status = Transaction::status($orderId);
            return response()->json($status);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    public function handleNotification(Request $request)
    {
        $notificationBody = json_decode($request->getContent(), true);
        $transactionStatus = $notificationBody['transaction_status'];
        $orderId = $notificationBody['order_id'];

        // Handle the transaction status accordingly
        // Update your database based on the transaction status

        return response()->json(['status' => 'success']);
    }
}
