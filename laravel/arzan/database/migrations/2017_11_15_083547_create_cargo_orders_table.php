<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateCargoOrdersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('cargo_orders', function (Blueprint $table) {
            $table->increments('id');
            $table->string('type')->default('cargo_orders');
            $table->integer('passenger_id');
            $table->integer('driver_id')->nullable();
            $table->string('from');
            $table->string('to');
            $table->integer('price');
            $table->text('text')->nullable();
            $table->boolean('document')->default(0);
            $table->boolean('bargain')->default(0);
            $table->boolean('status')->default(1);
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
        Schema::dropIfExists('cargo_orders');
    }
}
