<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\MenuController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\MenuController as ControllersMenuController;
use App\Http\Controllers\PemesananController;

Route::get('/menu', [ControllersMenuController::class, 'index']);
Route::get('/menu/{id}', [ControllersMenuController::class, 'show']);
Route::post('/menu', [ControllersMenuController::class, 'store']);
Route::put('/menu/{id}', [ControllersMenuController::class, 'update']);
Route::delete('/menu/{id}', [ControllersMenuController::class, 'destroy']);

Route::middleware('jwt.auth')->group(function () {
    Route::get('/me', [AuthController::class, 'me']);
    Route::post('/logout', [AuthController::class, 'logout']);
});
