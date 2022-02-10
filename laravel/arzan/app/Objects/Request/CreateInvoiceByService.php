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
 * Create invoice by service request.
 */
class CreateInvoiceByService extends CreateInvoiceExtended
{
    /**
     * Service name.
     *
     * @var string
     */
    protected $serviceName;

    /**
     * Card forbidden.
     *
     * @var string
     */
    protected $cardForbidden;

    /**
     * @see \Wooppay\Objects\Request\CreateInvoiceExtended::$serviceName
     *
     * @return string
     */
    public function getServiceName()
    {
        return $this->serviceName;
    }

    /**
     * @see \Wooppay\Objects\Request\CreateInvoiceExtended::$serviceName
     *
     * @param  string                                          $serviceName
     * @return \Wooppay\Objects\Request\CreateInvoiceByService
     */
    public function setServiceName($serviceName)
    {
        $this->serviceName = $serviceName;

        return $this;
    }

    /**
     * @see \Wooppay\Objects\Request\CreateInvoiceExtended::$cardForbidden
     *
     * @return string
     */
    public function getCardForbidden()
    {
        return $this->cardForbidden;
    }

    /**
     * @see \Wooppay\Objects\Request\CreateInvoiceExtended::$cardForbidden
     *
     * @param  string                                          $cardForbidden
     * @return \Wooppay\Objects\Request\CreateInvoiceByService
     */
    public function setCardForbidden($cardForbidden)
    {
        $this->cardForbidden = $cardForbidden;

        return $this;
    }
}
