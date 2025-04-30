folder delbites= flutter, 
folder delcafe = laravel

## langkah2 seteah pull project(tinggal salin)
1. composer update
2. composer require barryvdh/laravel-dompdf  
3. php artisan vendor:publish --provider="Tymon\JWTAuth\Providers\LaravelServiceProvider"
4. php artisan migrate
5. php artisan db:seed
6. php artisan serve

Run Step By Step
di laravel: php artisan serve --host=127.0.0.1 --port=8000
di cmd : adb reverse tcp:8000 tcp:8000
di flutter : flutter pub get

## untuk midtrans 
1. composer require midtrans/midtrans-php