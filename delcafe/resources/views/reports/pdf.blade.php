<!-- resources/views/reports/pdf.blade.php -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Laporan Pendapatan</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            font-size: 12px;
        }
        .header {
            text-align: center;
            margin-bottom: 20px;
        }
        .header h1 {
            margin: 0;
            padding: 0;
            font-size: 18px;
        }
        .header p {
            margin: 5px 0;
            color: #666;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        .summary {
            margin-top: 20px;
            text-align: right;
        }
        .footer {
            margin-top: 30px;
            text-align: center;
            font-size: 10px;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Laporan Pendapatan</h1>
        <p>Periode: {{ $startDate->format('d M Y') }} - {{ $endDate->format('d M Y') }}</p>
    </div>
    
    <div class="summary">
        <p><strong>Total Pendapatan:</strong> Rp {{ number_format($totalIncome, 0, ',', '.') }}</p>
        <p><strong>Total Pesanan:</strong> {{ $totalOrders }}</p>
    </div>
    
    <table>
        <thead>
            <tr>
                <th>ID Pesanan</th>
                <th>Tanggal</th>
                <th>Pelanggan</th>
                <th>Status</th>
                <th>Metode Pembayaran</th>
                <th>Total</th>
            </tr>
        </thead>
        <tbody>
            @foreach($orders as $order)
            <tr>
                <td>#ORD-{{ str_pad($order->id, 3, '0', STR_PAD_LEFT) }}</td>
                <td>{{ $order->created_at->format('d M Y H:i') }}</td>
                <td>{{ $order->pelanggan->nama }}</td>
                <td>{{ ucfirst($order->status) }}</td>
                <td>{{ $order->metode_pembayaran == 'cash' ? 'Tunai' : 'Transfer' }}</td>
                <td>Rp {{ number_format($order->total_harga, 0, ',', '.') }}</td>
            </tr>
            @endforeach
        </tbody>
    </table>
    
    <div class="footer">
        <p>Dicetak pada: {{ now()->format('d M Y H:i:s') }}</p>
        <p>&copy; Delbites 2025</p>
    </div>
</body>
</html>
