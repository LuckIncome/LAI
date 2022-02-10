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
 * Unsuccessful response exception.
 */
class UnsuccessfulResponse extends Exception
{
    /**
     * {@inheritdoc}
     *
     * @var string
     */
    protected $message = 'Unsuccessful response.';

    /**
     * {@inheritdoc}
     *
     * @param string          $message
     * @param integer         $code
     * @param \Exception|null $previous
     */
    public function __construct($message = "", $code = 0, \Exception $previous = null)
    {
        if (is_numeric($message) && $code === 0) {
            $this->code = $message;
        }

        parent::__construct($this->message, $this->code, $previous);
    }
}
