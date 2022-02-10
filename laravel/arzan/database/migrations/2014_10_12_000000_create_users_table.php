<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateUsersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('users', function (Blueprint $table) {
            $table->increments('id');
            $table->string('surname');
            $table->string('name');
            $table->string('middle_name');

            $table->string('phone')->unique();
            $table->integer('role')->default(1);
            $table->integer('city_id')->default(1);
            $table->string('lat')->default('43.238036');
            $table->string('lon')->default('76.910980');
            $table->string('avatar')->default('no image');
            $table->string('token')->unique();
            $table->string('promo_code')->unique();
            $table->integer('balanse')->default(0);
            $table->boolean('online')->default(1);


            $table->string('iin')->nullable();
            $table->string('id_card')->nullable();
            $table->string('expired_date')->nullable();
            $table->string('year')->nullable();
            $table->boolean('driver_was')->default(0);

            $table->rememberToken();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('users');
    }
}
