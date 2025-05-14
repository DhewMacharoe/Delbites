folder delbites= flutter, 
folder delcafe = laravel

## langkah2 seteah pull project(tinggal salin)
delcafe
1. composer update
2. composer require barryvdh/laravel-dompdf  
3. php artisan vendor:publish --provider="Tymon\JWTAuth\Providers\LaravelServiceProvider"
4. php artisan migrate
5. php artisan db:seed
6. adb reverse tcp:8000 tcp:8000 
7. php artisan serve --host=127.0.0.1 --port=8000
   
delbites: flutter pub get

## untuk midtrans 
1. composer require midtrans/midtrans-php
