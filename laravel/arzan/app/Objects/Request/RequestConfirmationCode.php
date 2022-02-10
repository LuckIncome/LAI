<?php
/**
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *
 * @author Igor Borodikhin <iborodikhin@gmail.com>
 * @license MIT
 */
namespace App\Objects\Request;

/**
 * Request confirmation code request.
 */
class RequestConfirmationCode
{
    /**
     * Phone number to send confirmation code to.
     *
     * @var string
     */
    protected $phone;

    /**
     * @see \Wooppay\Objects\Request\RequestConfirmationCode::$phone
     *
     * @return string
     */
    public function getPhone()
    {
        return $this->phone;
    }

    /**
     * @see \Wooppay\Objects\Request\RequestConfirmationCode::$phone
     *
     * @param  string                                           $phone
     * @return \Wooppay\Objects\Request\RequestConfirmationCode
     */
    public function setPhone($phone)
    {
        $this->phone = $phone;

        return $this;
    }
}
