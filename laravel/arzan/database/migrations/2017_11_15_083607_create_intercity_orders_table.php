<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateIntercityOrdersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('intercity_orders', function (Blueprint $table) {
            $table->increments('id');
            $table->string('type')->default('intercity_orders');
            $table->integer('passenger_id');
            $table->integer('driver_id')->nullable();
            $table->string('from');
            $table->string('to');
            $table->integer('price');
            $table->timestamp('date');
            $table->text('text')->nullable();
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
        Schema::dropIfExists('intercity_orders');
    }
}
