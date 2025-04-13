<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class WhatsAppWebhookController extends Controller
{
    public function receiveMessage(Request $request)
    {
        $message = $request->input('message');
        $phoneNumber = $request->input('from');
        preg_match('/\d{4}/', $message, $matches);
        $otp = $matches[0] ?? null;

        if (!$otp) {
            return response()->json(['error' => 'OTP tidak ditemukan'], 400);
        }
        $otpData = DB::table('otp_codes')
            ->where('phone_number', $phoneNumber)
            ->where('otp_code', $otp)
            ->where('expires_at', '>=', now())
            ->first();

        if ($otpData) {
            return response()->json(['message' => 'OTP valid! Verifikasi berhasil']);
        } else {
            return response()->json(['error' => 'OTP salah atau kadaluarsa!'], 400);
        }
    }
}
