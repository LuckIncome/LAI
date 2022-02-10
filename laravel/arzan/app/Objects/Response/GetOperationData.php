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
 * Get operation data response.
 */
class GetOperationData extends Base
{
    /**
     * Status — new.
     */
    const STATUS_NEW = 1;

    /**
     * Status — consider.
     */
    const STATUS_CONSIDER = 2;

    /**
     * Status — rejected.
     */
    const STATUS_REJECTED = 3;

    /**
     * Status — done.
     */
    const STATUS_DONE = 4;

    /**
     * Status — canceled.
     */
    const STATUS_CANCELED = 5;

    /**
     * Status — canceling.
     */
    const STATUS_CANCELING = 6;

    /**
     * Operation id.
     *
     * @var integer
     */
    protected $id;

    /**
     * Operation type.
     *
     * @var integer
     */
    protected $type;

    /**
     * Lot id.
     *
     * @var integer
     */
    protected $lotId;

    /**
     * Sum.
     *
     * @var integer
     */
    protected $sum;

    /**
     * Creation date.
     *
     * @var string
     */
    protected $date;

    /**
     * Operation status.
     *
     * @var integer
     */
    protected $status;

    /**
     * Comment.
     *
     * @var string
     */
    protected $comment;

    /**
     * Sender login.
     *
     * @var string
     */
    protected $fromSubject;

    /**
     * Recipient login.
     *
     * @var string
     */
    protected $toSubject;

    /**
     * Sender full name.
     *
     * @var string
     */
    protected $fromFullName;

    /**
     * Recipient full name.
     *
     * @var string
     */
    protected $toFullName;

    /**
     * @see \Wooppay\Objects\Response\GetOperationData::$id
     *
     * @return integer
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * @see \Wooppay\Objects\Response\GetOperationData::$id
     *
     * @param  integer                                    $id
     * @return \Wooppay\Objects\Response\GetOperationData
     */
    public function setId($id)
    {
        $this->id = $id;

        return $this;
    }

    /**
     * @see \Wooppay\Objects\Response\GetOperationData::$type
     *
     * @return integer
     */
    public function getType()
    {
        return $this->type;
    }

    /**
     * @see \Wooppay\Objects\Response\GetOperationData::$type
     *
     * @param  integer                                    $type
     * @return \Wooppay\Objects\Response\GetOperationData
     */
    public function setType($type)
    {
        $this->type = $type;

        return $this;
    }

    /**
     * @see \Wooppay\Objects\Response\GetOperationData::$lotId
     *
     * @return integer
     */
    public function getLotId()
    {
        return $this->lotId;
    }

    /**
     * @see \Wooppay\Objects\Response\GetOperationData::$lotId
     *
     * @param  integer                                    $lotId
     * @return \Wooppay\Objects\Response\GetOperationData
     */
    public function setLotId($lotId)
    {
        $this->lotId = $lotId;

        return $this;
    }

    /**
     * @see \Wooppay\Objects\Response\GetOperationData::$sum
     *
     * @return integer
     */
    public function getSum()
    {
        return $this->sum;
    }

    /**
     * @see \Wooppay\Objects\Response\GetOperationData::$sum
     *
     * @param  integer                                    $sum
     * @return \Wooppay\Objects\Response\GetOperationData
     */
    public function setSum($sum)
    {
        $this->sum = $sum;

        return $this;
    }

    /**
     * @see \Wooppay\Objects\Response\GetOperationData::$date
     *
     * @return string
     */
    public function getDate()
    {
        return $this->date;
    }

    /**
     * @see \Wooppay\Objects\Response\GetOperationData::$date
     *
     * @param  string                                     $date
     * @return \Wooppay\Objects\Response\GetOperationData
     */
    public function setDate($date)
    {
        $this->date = $date;

        return $this;
    }

    /**
     * @see \Wooppay\Objects\Response\GetOperationData::$status
     *
     * @return integer
     */
    public function getStatus()
    {
        return $this->status;
    }

    /**
     * @see \Wooppay\Objects\Response\GetOperationData::$status
     *
     * @param  integer                                    $status
     * @return \Wooppay\Objects\Response\GetOperationData
     */
    public function setStatus($status)
    {
        $this->status = $status;

        return $this;
    }

    /**
     * @see \Wooppay\Objects\Response\GetOperationData::$comment
     *
     * @return string
     */
    public function getComment()
    {
        return $this->comment;
    }

    /**
     * @see \Wooppay\Objects\Response\GetOperationData::$comment
     *
     * @param  string                                     $comment
     * @return \Wooppay\Objects\Response\GetOperationData
     */
    public function setComment($comment)
    {
        $this->comment = $comment;

        return $this;
    }

    /**
     * @see \Wooppay\Objects\Response\GetOperationData::$fromSubject
     *
     * @return string
     */
    public function getFromSubject()
    {
        return $this->fromSubject;
    }

    /**
     * @see \Wooppay\Objects\Response\GetOperationData::$fromSubject
     *
     * @param  string                                     $fromSubject
     * @return \Wooppay\Objects\Response\GetOperationData
     */
    public function setFromSubject($fromSubject)
    {
        $this->fromSubject = $fromSubject;

        return $this;
    }

    /**
     * @see \Wooppay\Objects\Response\GetOperationData::$toSubject
     *
     * @return string
     */
    public function getToSubject()
    {
        return $this->toSubject;
    }

    /**
     * @see \Wooppay\Objects\Response\GetOperationData::$toSubject
     *
     * @param  string                                     $toSubject
     * @return \Wooppay\Objects\Response\GetOperationData
     */
    public function setToSubject($toSubject)
    {
        $this->toSubject = $toSubject;

        return $this;
    }

    /**
     * @see \Wooppay\Objects\Response\GetOperationData::$fromFullName
     *
     * @return string
     */
    public function getFromFullName()
    {
        return $this->fromFullName;
    }

    /**
     * @see \Wooppay\Objects\Response\GetOperationData::$toFullName
     *
     * @param  string                                     $fromFullName
     * @return \Wooppay\Objects\Response\GetOperationData
     */
    public function setFromFullName($fromFullName)
    {
        $this->fromFullName = $fromFullName;

        return $this;
    }

    /**
     * @see \Wooppay\Objects\Response\GetOperationData::$toFullName
     *
     * @return string
     */
    public function getToFullName()
    {
        return $this->toFullName;
    }

    /**
     * @see \Wooppay\Objects\Response\GetOperationData::$toFullName
     *
     * @param  string                                     $toFullName
     * @return \Wooppay\Objects\Response\GetOperationData
     */
    public function setToFullName($toFullName)
    {
        $this->toFullName = $toFullName;
        
        return $this;
    }

    /**
     * {@inhertidoc}
     *
     * @param  mixed                                            $data
     * @return array
     * @throws \Wooppay\Objects\Exceptions\BadCredentials
     * @throws \Wooppay\Objects\Exceptions\UnsuccessfulResponse
     */
    public static function factory($data)
    {
        $result = [];

        if (self::checkResponse($data)) {
            foreach ($data->response->records as $item) {
                if ($item) {
                    $result[] = (new self())
                        ->setId($item->id)
                        ->setType($item->type)
                        ->setLotId($item->lotId)
                        ->setSum($item->sum)
                        ->setDate($item->date)
                        ->setStatus($item->status)
                        ->setComment($item->comment)
                        ->setFromSubject($item->fromSubject)
                        ->setToSubject($item->toSubject)
                        ->setFromFullName($item->fromFullName)
                        ->setToFullName($item->toFullName);
                }
            }
        }

        return $result;
    }
}
