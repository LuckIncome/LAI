<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateTaxiOrdersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('taxi_orders', function (Blueprint $table) {
            $table->increments('id');
            $table->string('type')->default('taxi_orders');
            $table->integer('passenger_id');
            $table->integer('driver_id')->nullable();
            $table->string('from');
            $table->string('from_lat')->nullable();
            $table->string('from_lon')->nullable();
            $table->string('to');
            $table->string('to_lat')->nullable();
            $table->string('to_lon')->nullable();
            $table->integer('price');
            $table->integer('count_passenger')->default(1);
            $table->boolean('get_passenger')->default(0);
            $table->boolean('bonus')->default(0);
            $table->boolean('status')->default(1);
            $table->integer('step')->default(1);
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
        Schema::dropIfExists('taxi_orders');
    }
}
