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
 * Get operation data request.
 */
class GetOperationData
{
    /**
     * Operations ids.
     *
     * @var array
     */
    protected $operationId;

    /**
     * @see \Wooppay\Objects\Request\GetOperationData::$operationId
     * @return array
     */
    public function getOperationId()
    {
        return $this->operationId;
    }

    /**
     * @see \Wooppay\Objects\Request\GetOperationData::$operationId
     * @param  array                                     $operationId
     * @return \Wooppay\Objects\Request\GetOperationData
     */
    public function setOperationId($operationId)
    {
        $this->operationId = $operationId;

        return $this;
    }
}
