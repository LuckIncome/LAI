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
 * Create invoice extended response.
 */
class CreateInvoiceExtended extends Base
{
    /**
     * Operation id.
     *
     * @var integer
     */
    protected $operationId;

    /**
     * Payment form URI.
     *
     * @var string
     */
    protected $operationUrl;

    /**
     * @see \Wooppay\Objects\Response\CreateInvoiceExtended::$operationId
     *
     * @return integer
     */
    public function getOperationId()
    {
        return $this->operationId;
    }

    /**
     * @see \Wooppay\Objects\Response\CreateInvoiceExtended::$operationId
     *
     * @param  integer                                         $operationId
     * @return \Wooppay\Objects\Response\CreateInvoiceExtended
     */
    public function setOperationId($operationId)
    {
        $this->operationId = $operationId;

        return $this;
    }

    /**
     * @see \Wooppay\Objects\Response\CreateInvoiceExtended::$operationUrl
     *
     * @return string
     */
    public function getOperationUrl()
    {
        return $this->operationUrl;
    }

    /**
     * @see \Wooppay\Objects\Response\CreateInvoiceExtended::$operationUrl
     *
     * @param  string                                          $operationUrl
     * @return \Wooppay\Objects\Response\CreateInvoiceExtended
     */
    public function setOperationUrl($operationUrl)
    {
        $this->operationUrl = $operationUrl;

        return $this;
    }

    /**
     * {@inheritdoc}
     *
     * @param  mixed                                            $data
     * @return \Wooppay\Objects\Response\CreateInvoiceExtended
     * @throws \Wooppay\Objects\Exceptions\BadCredentials
     * @throws \Wooppay\Objects\Exceptions\UnsuccessfulResponse
     */
    public static function factory($data)
    {
        $response = new self();

        if (self::checkResponse($data)) {
            $response
                ->setOperationId($data->response->operationId)
                ->setOperationUrl($data->response->operationUrl);
        }

        return $response;
    }
}
