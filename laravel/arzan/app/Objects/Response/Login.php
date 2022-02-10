<?php
/**
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *
 * @author Igor Borodikhin <iborodikhin@gmail.com>
 * @license MIT
 */
namespace App\Objects\Response;

/**
 * Login response.
 */
class Login extends Base
{
    /**
     * Session id.
     *
     * @var string
     */
    protected $session;

    /**
     * User id.
     *
     * @var integer
     */
    protected $id;

    /**
     * User name.
     *
     * @var string
     */
    protected $username;

    /**
     * User login.
     *
     * @var string
     */
    protected $login;

    /**
     * User type.
     *
     * @var integer
     */
    protected $type;

    /**
     * User roles.
     *
     * @var array
     */
    protected $roles;

    /**
     * @see \Wooppay\Objects\Response\CoreLogin::$session
     *
     * @return string
     */
    public function getSession()
    {
        return $this->session;
    }

    /**
     * @see \Wooppay\Objects\Response\CoreLogin::$session
     *
     * @param  string                          $session
     * @return \Wooppay\Objects\Response\Login
     */
    public function setSession($session)
    {
        $this->session = $session;

        return $this;
    }

    /**
     * @see \Wooppay\Objects\Response\CoreLogin::$id
     *
     * @return integer
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * @see \Wooppay\Objects\Response\CoreLogin::$id
     *
     * @param  integer                         $id
     * @return \Wooppay\Objects\Response\Login
     */
    public function setId($id)
    {
        $this->id = $id;

        return $this;
    }

    /**
     * @see \Wooppay\Objects\Response\CoreLogin::$username
     *
     * @return string
     */
    public function getUsername()
    {
        return $this->username;
    }

    /**
     * @see \Wooppay\Objects\Response\CoreLogin::$username
     *
     * @param  string                          $username
     * @return \Wooppay\Objects\Response\Login
     */
    public function setUsername($username)
    {
        $this->username = $username;

        return $this;
    }

    /**
     * @see \Wooppay\Objects\Response\CoreLogin::$login
     *
     * @return string
     */
    public function getLogin()
    {
        return $this->login;
    }

    /**
     * @see \Wooppay\Objects\Response\CoreLogin::$login
     *
     * @param  string                          $login
     * @return \Wooppay\Objects\Response\Login
     */
    public function setLogin($login)
    {
        $this->login = $login;

        return $this;
    }

    /**
     * @see \Wooppay\Objects\Response\CoreLogin::$type
     *
     * @return integer
     */
    public function getType()
    {
        return $this->type;
    }

    /**
     * @see \Wooppay\Objects\Response\CoreLogin::$type
     *
     * @param  integer                         $type
     * @return \Wooppay\Objects\Response\Login
     */
    public function setType($type)
    {
        $this->type = $type;

        return $this;
    }

    /**
     * @see \Wooppay\Objects\Response\CoreLogin::$roles
     *
     * @return array
     */
    public function getRoles()
    {
        return $this->roles;
    }

    /**
     * @see \Wooppay\Objects\Response\CoreLogin::$roles
     *
     * @param  array                           $roles
     * @return \Wooppay\Objects\Response\Login
     */
    public function setRoles($roles)
    {
        $this->roles = $roles;

        return $this;
    }

    /**
     * {@inheritdoc}
     *
     * @param  mixed                                            $data
     * @return \Wooppay\Objects\Response\Login
     * @throws \Wooppay\Objects\Exceptions\BadCredentials
     * @throws \Wooppay\Objects\Exceptions\UnsuccessfulResponse
     */
    public static function factory($data)
    {
        $response = new self();

        if (self::checkResponse($data)) {
            $response
                ->setSession($data->response->session)
                ->setId($data->response->id)
                ->setUsername($data->response->username)
                ->setLogin($data->response->login)
                ->setType($data->response->type)
                ->setRoles($data->response->roles);
        }

        return $response;
    }
}
