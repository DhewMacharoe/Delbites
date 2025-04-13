<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Carbon\Carbon;

class OTPController extends Controller
{
    public function generateOTP(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'phone_number' => 'required|string|max:15',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => 'Nomor HP tidak valid'], 400);
        }

        $otp = rand(1000, 9999);
        $phone = $request->phone_number;
        $expiresAt = Carbon::now()->addMinutes(5);

        DB::table('otp_codes')->updateOrInsert(
            ['phone_number' => $phone],
            ['otp_code' => $otp, 'expires_at' => $expiresAt, 'created_at' => Carbon::now()]
        );

        $whatsappMessage = "Halo, saya ingin verifikasi nomor HP. Kode OTP saya: *$otp*";
        $whatsappUrl = "https://wa.me/6281260846741?text=" . urlencode($whatsappMessage);

        return response()->json([
            'message' => 'Silakan kirim kode OTP ke WhatsApp admin!',
            'whatsapp_url' => $whatsappUrl
        ]);
    }
}
