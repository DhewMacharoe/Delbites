<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('menu', function (Blueprint $table) {
            $table->id('menu_id');
            $table->unsignedBigInteger('admin_id')->nullable();
            $table->string('nama_menu');
            $table->string('kategori');
            $table->decimal('harga', 10, 2);
            $table->integer('stok')->default(0);
            $table->string('gambar')->nullable();
            $table->integer('stok_terjual')->default(0);
            $table->timestamps();

            $table->foreign('admin_id')
                  ->references('id_admin')
                  ->on('admin')
                  ->onDelete('set null');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('menu');
    }
};
