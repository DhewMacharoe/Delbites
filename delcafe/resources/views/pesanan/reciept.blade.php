<!-- resources/views/orders/receipt.blade.php -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Struk Pesanan #{{ $order->id }}</title>
    <style>
        body {
            font-family: 'Courier New', monospace;
            font-size: 10px;
            width: 80mm;
            margin: 0 auto;
        }
        .header {
            text-align: center;
            margin-bottom: 10px;
        }
        .header h1 {
            margin: 0;
            padding: 0;
            font-size: 14px;
        }
        .header p {
            margin: 2px 0;
            font-size: 8px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 10px;
        }
        th, td {
            padding: 3px 0;
            text-align: left;
        }
        .right {
            text-align: right;
        }
        .center {
            text-align: center;
        }
        .divider {
            border-top: 1px dashed #000;
            margin: 5px 0;
        }
        .footer {
            margin-top: 10px;
            text-align: center;
            font-size: 8px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>DELBITES</h1>
        <p>Jl. Merdeka No. 123, Jakarta</p>
        <p>Telp: (021) 123-4567</p>
        <p>================================</p>
        <h2>STRUK PESANAN</h2>
        <p>No: #ORD-{{ str_pad($order->id, 3, '0', STR_PAD_LEFT) }}</p>
        <p>Tanggal: {{ $order->created_at->format('d/m/Y H:i') }}</p>
        <p>Kasir: Admin</p>
        <p>================================</p>
    </div>
    
    <table>
        <tr>
            <td colspan="2">Pelanggan: {{ $order->customer->name }}</td>
        </tr>
        <tr>
            <td colspan="2">Status: {{ ucfirst($order->status) }}</td>
        </tr>
        <tr>
            <td colspan="2">Pembayaran: {{ $order->payment_method == 'cash' ? 'Tunai' : 'Transfer' }}</td>
        </tr>
    </table>
    
    <div class="divider"></div>
    
    <table>
        <tr>
            <th>Item</th>
            <th class="right">Qty</th>
            <th class="right">Harga</th>
            <th class="right">Subtotal</th>
        </tr>
        @foreach($order->items as $item)
        <tr>
            <td>{{ $item->product->name }}</td>
            <td class="right">{{ $item->quantity }}</td>
            <td class="right">{{ number_format($item->price, 0, ',', '.') }}</td>
            <td class="right">{{ number_format($item->price * $item->quantity, 0, ',', '.') }}</td>
        </tr>
        @endforeach
    </table>
    
    <div class="divider"></div>
    
    <table>
        <tr>
            <th>TOTAL</th>
            <th class="right">Rp {{ number_format($order->total_amount, 0, ',', '.') }}</th>
        </tr>
    </table>
    
    @if($order->notes)
    <div class="divider"></div>
    <p><strong>Catatan:</strong> {{ $order->notes }}</p>
    @endif
    
    <div class="divider"></div>
    
    <div class="footer">
        <p>Terima kasih atas kunjungan Anda!</p>
        <p>&copy; Delbites 2025</p>
    </div>
</body>
</html>