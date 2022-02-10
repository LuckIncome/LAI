<?php
/**
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *
 * @author Igor Borodikhin <iborodikhin@gmail.com>
 * @license MIT
 */
namespace App\Objects\Interfaces;

/**
 * Response interface.
 */
interface Response
{
    /**
     * Constructs object from response.
     *
     * @param $data
     * @return mixed
     */
    public static function factory($data);
}
