<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('pesanan', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('id_pelanggan');
            $table->foreign('id_pelanggan')->references('id')->on('pelanggan');
            $table->decimal('total_harga', 10, 2);
            $table->enum('status', ['menunggu', 'pembayaran', 'dibayar', 'diproses', 'selesai', 'dibatalkan'])->default('menunggu');
            $table->enum('metode_pembayaran', ['tunai', 'transfer'])->default('tunai');
            $table->text('catatan')->nullable();
            $table->string('bukti_pembayaran')->nullable();
            $table->unsignedBigInteger('id_admin')->nullable();
            $table->foreign('id_admin')->references('id_admin')->on('admin')->onDelete('set null');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pesanan');
    }
};