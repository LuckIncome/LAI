<?php
/**
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *
 * @author Igor Borodikhin <iborodikhin@gmail.com>
 * @license MIT
 */
namespace App\Objects\Exceptions;

/**
 * Bad credentials exception.
 */
class BadCredentials extends Exception
{
    /**
     * {@inheritdoc}
     *
     * @var string
     */
    protected $message = 'Bad credentials.';
}
