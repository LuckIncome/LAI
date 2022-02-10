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
 * Login request.
 */
class Login
{
    /**
     * Username field.
     *
     * @var string
     */
    protected $username;

    /**
     * Password field.
     *
     * @var string
     */
    protected $password;

    /**
     * Captcha field.
     *
     * @var string
     */
    protected $captcha;

    /**
     * @see \Wooppay\Objects\Request\CoreLogin::$username
     *
     * @return string
     */
    public function getUsername()
    {
        return $this->username;
    }

    /**
     * @see \Wooppay\Objects\Request\CoreLogin::$username
     *
     * @param  string                         $username
     * @return \Wooppay\Objects\Request\Login
     */
    public function setUsername($username)
    {
        $this->username = $username;

        return $this;
    }

    /**
     * @see \Wooppay\Objects\Request\CoreLogin::$password
     *
     * @return string
     */
    public function getPassword()
    {
        return $this->password;
    }

    /**
     * @see \Wooppay\Objects\Request\CoreLogin::$password
     *
     * @param  string                         $password
     * @return \Wooppay\Objects\Request\Login
     */
    public function setPassword($password)
    {
        $this->password = $password;

        return $this;
    }

    /**
     * @see \Wooppay\Objects\Request\CoreLogin::$captcha
     *
     * @return string
     */
    public function getCaptcha()
    {
        return $this->captcha;
    }

    /**
     * @see \Wooppay\Objects\Request\CoreLogin::$captcha
     *
     * @param  string                         $captcha
     * @return \Wooppay\Objects\Request\Login
     */
    public function setCaptcha($captcha)
    {
        $this->captcha = $captcha;

        return $this;
    }
}
