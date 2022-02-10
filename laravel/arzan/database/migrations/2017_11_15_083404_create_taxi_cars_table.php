<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateTaxiCarsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('taxi_cars', function (Blueprint $table) {
            $table->increments('id');
            $table->string('type')->default('taxi_cars');;
            $table->integer('user_id');
            $table->integer('car_mark_id');
            $table->integer('car_model_id');
            $table->string('year');
            $table->integer('color_id');
            $table->boolean('vip')->default(0);
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
        Schema::dropIfExists('taxi_cars');
    }
}
