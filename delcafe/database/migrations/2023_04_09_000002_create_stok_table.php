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
        Schema::create('stok', function (Blueprint $table) {
            $table->id('stok_id'); // kolom ID stok
            $table->string('nama_barang'); // nama barang
            $table->integer('jumlah'); // jumlah stok
            $table->string('satuan'); // satuan barang
            $table->unsignedBigInteger('admin_id'); // ID admin
            $table->foreign('admin_id')->references('id_admin')->on('admin')->onDelete('cascade');
            $table->timestamps(); // created_at dan updated_at
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('stok');
    }
};
