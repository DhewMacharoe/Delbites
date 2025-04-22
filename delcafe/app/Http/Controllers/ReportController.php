<?php

namespace App\Http\Controllers;

use App\Models\Pesanan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;
use Barryvdh\DomPDF\Facade\Pdf;
use Maatwebsite\Excel\Facades\Excel;
use App\Exports\OrdersExport;

class ReportController extends Controller
{
    public function index(Request $request)
    {
        $period = $request->input('period', 'daily');
        $startDate = $request->input('start_date', Carbon::now()->startOfMonth()->format('Y-m-d'));
        $endDate = $request->input('end_date', Carbon::now()->format('Y-m-d'));

        $startDate = Carbon::parse($startDate)->startOfDay();
        $endDate = Carbon::parse($endDate)->endOfDay();

        $query = Pesanan::whereIn('status', ['dibayar', 'diproses', 'selesai'])
                    ->whereBetween('created_at', [$startDate, $endDate]);

        if ($period === 'monthly') {
            $reports = $query->select(
                DB::raw('YEAR(created_at) as year'),
                DB::raw('MONTH(created_at) as month'),
                DB::raw('SUM(total_harga) as total_income'),
                DB::raw('COUNT(*) as total_orders')
            )
            ->groupBy('year', 'month')
            ->orderBy('year', 'desc')
            ->orderBy('month', 'desc')
            ->get()
            ->map(function ($item) {
                $date = Carbon::createFromDate($item->year, $item->month, 1);
                return [
                    'period' => $date->format('F Y'),
                    'total_income' => $item->total_income,
                    'total_orders' => $item->total_orders,
                    'year' => $item->year,
                    'month' => $item->month,
                ];
            });
        } else {
            $reports = $query->select(
                DB::raw('DATE(created_at) as date'),
                DB::raw('SUM(total_harga) as total_income'),
                DB::raw('COUNT(*) as total_orders')
            )
            ->groupBy('date')
            ->orderBy('date', 'desc')
            ->get()
            ->map(function ($item) {
                $date = Carbon::parse($item->date);
                return [
                    'period' => $date->format('d F Y'),
                    'total_income' => $item->total_income,
                    'total_orders' => $item->total_orders,
                    'date' => $item->date,
                ];
            });
        }

        $orders = Pesanan::with(['pelanggan', 'items.produk', 'admin'])
                    ->whereIn('status', ['dibayar', 'diproses', 'selesai'])
                    ->whereBetween('created_at', [$startDate, $endDate])
                    ->orderBy('created_at', 'desc')
                    ->get();

        $totalIncome = $orders->sum('total_harga');
        $totalOrders = $orders->count();

        return view('reports.index', compact(
            'reports',
            'orders',
            'period',
            'startDate',
            'endDate',
            'totalIncome',
            'totalOrders'
        ));
    }

    public function exportPdf(Request $request)
    {
        $startDate = $request->input('start_date', Carbon::now()->startOfMonth()->format('Y-m-d'));
        $endDate = $request->input('end_date', Carbon::now()->format('Y-m-d'));

        $startDate = Carbon::parse($startDate)->startOfDay();
        $endDate = Carbon::parse($endDate)->endOfDay();

        $orders = Pesanan::with(['pelanggan', 'items', 'admin'])
                    ->whereIn('status', ['dibayar', 'diproses', 'selesai'])
                    ->whereBetween('created_at', [$startDate, $endDate])
                    ->orderBy('created_at', 'desc')
                    ->get();

        $totalIncome = $orders->sum('total_harga');
        $totalOrders = $orders->count();

        $pdf = PDF::loadView('reports.pdf', compact('orders', 'startDate', 'endDate', 'totalIncome', 'totalOrders'));

        return $pdf->download('laporan-' . $startDate->format('Y-m-d') . '-to-' . $endDate->format('Y-m-d') . '.pdf');
    }

    public function exportExcel(Request $request)
    {
        $startDate = $request->input('start_date', Carbon::now()->startOfMonth()->format('Y-m-d'));
        $endDate = $request->input('end_date', Carbon::now()->format('Y-m-d'));

        return Excel::download(new OrdersExport($startDate, $endDate), 'laporan-' . $startDate . '-to-' . $endDate . '.xlsx');
    }

    public function receipt(Pesanan $order)
    {
        $order->load(['pelanggan', 'items', 'admin']);

        $pdf = PDF::loadView('reports.receipt', compact('order'));

        return $pdf->download('struk-' . $order->id . '.pdf');
    }
}
