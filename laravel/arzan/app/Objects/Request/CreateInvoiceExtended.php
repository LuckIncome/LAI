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
 * Create invoice extended request.
 */
class CreateInvoiceExtended
{
    /**
     * Default service type.
     */
    const DEFAULT_SERVICE_TYPE = 2;

    /**
     * Provider reference id.
     *
     * @var string
     */
    protected $referenceId;

    /**
     * Return url.
     *
     * @var string
     */
    protected $backUrl;

    /**
     * Post-back notification url.
     *
     * @var string
     */
    protected $requestUrl;

    /**
     * Confirmation code.
     *
     * @var string
     */
    protected $addInfo;

    /**
     * Invoice amount.
     *
     * @var float
     */
    protected $amount;

    /**
     * Invoice validity date.
     *
     * @var string
     */
    protected $deathDate;

    /**
     * Service type.
     *
     * @var integer
     */
    protected $serviceType;

    /**
     * Description.
     *
     * @var string
     */
    protected $description;

    /**
     * Order number.
     *
     * @var string
     */
    protected $orderNumber;

    /**
     * User email.
     *
     * @var string
     */
    protected $userEmail;

    /**
     * User phone.
     *
     * @var string
     */
    protected $userPhone;

    /**
     * @see \Wooppay\Objects\Request\CreateInvoiceExtended::$referenceId
     *
     * @return string
     */
    public function getReferenceId()
    {
        return $this->referenceId;
    }

    /**
     * @see \Wooppay\Objects\Request\CreateInvoiceExtended::$referenceId
     *
     * @param  string                                         $referenceId
     * @return \Wooppay\Objects\Request\CreateInvoiceExtended
     */
    public function setReferenceId($referenceId)
    {
        $this->referenceId = $referenceId;
        
        return $this;
    }

    /**
     * @see \Wooppay\Objects\Request\CreateInvoiceExtended::$backUrl
     *
     * @return string
     */
    public function getBackUrl()
    {
        return $this->backUrl;
    }

    /**
     * @see \Wooppay\Objects\Request\CreateInvoiceExtended::$backUrl
     *
     * @param  string                                         $backUrl
     * @return \Wooppay\Objects\Request\CreateInvoiceExtended
     */
    public function setBackUrl($backUrl)
    {
        $this->backUrl = $backUrl;

        return $this;
    }

    /**
     * @see \Wooppay\Objects\Request\CreateInvoiceExtended::$requestUrl
     *
     * @return string
     */
    public function getRequestUrl()
    {
        return $this->requestUrl;
    }

    /**
     * @see \Wooppay\Objects\Request\CreateInvoiceExtended::$requestUrl
     *
     * @param  string                                         $requestUrl
     * @return \Wooppay\Objects\Request\CreateInvoiceExtended
     */
    public function setRequestUrl($requestUrl)
    {
        $this->requestUrl = $requestUrl;

        return $this;
    }

    /**
     * @see \Wooppay\Objects\Request\CreateInvoiceExtended::$addInfo
     *
     * @return string
     */
    public function getAddInfo()
    {
        return $this->addInfo;
    }

    /**
     * @see \Wooppay\Objects\Request\CreateInvoiceExtended::$addInfo
     *
     * @param  string                                         $addInfo
     * @return \Wooppay\Objects\Request\CreateInvoiceExtended
     */
    public function setAddInfo($addInfo)
    {
        $this->addInfo = $addInfo;

        return $this;
    }

    /**
     * @see \Wooppay\Objects\Request\CreateInvoiceExtended::$amount
     *
     * @return float
     */
    public function getAmount()
    {
        return $this->amount;
    }

    /**
     * @see \Wooppay\Objects\Request\CreateInvoiceExtended::$amount
     *
     * @param  float                                          $amount
     * @return \Wooppay\Objects\Request\CreateInvoiceExtended
     */
    public function setAmount($amount)
    {
        $this->amount = $amount;

        return $this;
    }

    /**
     * @see \Wooppay\Objects\Request\CreateInvoiceExtended::$deathDate
     *
     * @return string
     */
    public function getDeathDate()
    {
        return $this->deathDate;
    }

    /**
     * @see \Wooppay\Objects\Request\CreateInvoiceExtended::$deathDate
     *
     * @param  string                                         $deathDate
     * @return \Wooppay\Objects\Request\CreateInvoiceExtended
     */
    public function setDeathDate($deathDate)
    {
        $this->deathDate = $deathDate;

        return $this;
    }

    /**
     * @see \Wooppay\Objects\Request\CreateInvoiceExtended::$serviceType
     *
     * @return integer
     */
    public function getServiceType()
    {
        return $this->serviceType;
    }

    /**
     * @see \Wooppay\Objects\Request\CreateInvoiceExtended::$serviceType
     *
     * @param  integer                                        $serviceType
     * @return \Wooppay\Objects\Request\CreateInvoiceExtended
     */
    public function setServiceType($serviceType)
    {
        $this->serviceType = $serviceType;

        return $this;
    }

    /**
     * @see \Wooppay\Objects\Request\CreateInvoiceExtended::$description
     *
     * @return string
     */
    public function getDescription()
    {
        return $this->description;
    }

    /**
     * @see \Wooppay\Objects\Request\CreateInvoiceExtended::$description
     *
     * @param  string                                         $description
     * @return \Wooppay\Objects\Request\CreateInvoiceExtended
     */
    public function setDescription($description)
    {
        $this->description = $description;

        return $this;
    }

    /**
     * @see \Wooppay\Objects\Request\CreateInvoiceExtended::$orderNumber
     *
     * @return string
     */
    public function getOrderNumber()
    {
        return $this->orderNumber;
    }

    /**
     * @see \Wooppay\Objects\Request\CreateInvoiceExtended::$orderNumber
     *
     * @param  string                                         $orderNumber
     * @return \Wooppay\Objects\Request\CreateInvoiceExtended
     */
    public function setOrderNumber($orderNumber)
    {
        $this->orderNumber = $orderNumber;

        return $this;
    }

    /**
     * @see \Wooppay\Objects\Request\CreateInvoiceExtended::$userEmail
     *
     * @return string
     */
    public function getUserEmail()
    {
        return $this->userEmail;
    }

    /**
     * @see \Wooppay\Objects\Request\CreateInvoiceExtended::$userEmail
     *
     * @param  string                                         $userEmail
     * @return \Wooppay\Objects\Request\CreateInvoiceExtended
     */
    public function setUserEmail($userEmail)
    {
        $this->userEmail = $userEmail;

        return $this;
    }

    /**
     * @see \Wooppay\Objects\Request\CreateInvoiceExtended::$userPhone
     *
     * @return string
     */
    public function getUserPhone()
    {
        return $this->userPhone;
    }

    /**
     * @see \Wooppay\Objects\Request\CreateInvoiceExtended::$userPhone
     *
     * @param  string                                         $userPhone
     * @return \Wooppay\Objects\Request\CreateInvoiceExtended
     */
    public function setUserPhone($userPhone)
    {
        $this->userPhone = $userPhone;

        return $this;
    }
}
