<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateKeranjangTable extends Migration
{
    public function up()
    {
        Schema::create('keranjang', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('id_pelanggan');
            $table->unsignedBigInteger('id_menu');
            $table->string('nama_menu');
            $table->enum('kategori', ['makanan', 'minuman'])->nullable();
            $table->string('suhu')->nullable(); // Added for drink temperature
            $table->integer('jumlah')->default(1);
            $table->decimal('harga', 10, 2);
            $table->text('catatan')->nullable(); // Added for additional notes
            $table->timestamps();

            // Foreign key constraints
            $table->foreign('id_pelanggan')->references('id')->on('pelanggan')->onDelete('cascade');
            $table->foreign('id_menu')->references('id')->on('menu')->onDelete('cascade');
        });
    }

    public function down()
    {
        Schema::dropIfExists('keranjang');
    }
}