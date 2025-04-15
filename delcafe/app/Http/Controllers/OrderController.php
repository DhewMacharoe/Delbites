<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Order;

class OrderController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'customer_id' => 'required|exists:customers,id',
            'total_amount' => 'required|numeric|min:0',
            'notes' => 'nullable|string',
        ]);

        $order = Order::create($request->all());

        return response()->json([
            'message' => 'Order berhasil disimpan!',
            'order' => $order,
        ], 201);
    }
}
