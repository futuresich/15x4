<?php

namespace AppBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * @ORM\Table(name="city")
 * @ORM\Entity(repositoryClass="AppBundle\Entity\Repository\CityRepository")
 */
class City
{
    /**
     * @ORM\Column(name="id", type="integer")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    private $id;

    /**
     * @var \AppBundle\Entity\Event[]
     * @ORM\OneToMany(targetEntity="\AppBundle\Entity\Event", mappedBy="city")
     */
    protected $events;

    /**
     * @var \AppBundle\Entity\Announcement[]
     * @ORM\OneToMany(targetEntity="\AppBundle\Entity\Announcement", mappedBy="city")
     */
    protected $announcements;

    /**
     * @ORM\Column(name="name", type="string", length=63, nullable=false, unique=true)
     */
    protected $name;

    /** {@inheritdoc} */
    public function __toString()
    {
        return $this->getName();
    }

    /** @return int */
    public function getId()
    {
        return $this->id;
    }

    /** @return string */
    public function getName()
    {
        return $this->name;
    }

    /** @param string $name */
    public function setName($name)
    {
        $this->name = $name;
    }

    /** @return Announcement[] */
    public function getAnnouncements()
    {
        return $this->announcements;
    }

    /** @return Announcement|null */
    public function getNextAnnouncement()
    {
        foreach ($this->getAnnouncements() as $announcement) {
            if ($announcement->getDate() >= (new \DateTime)->modify('today midnight')) {
                return $announcement;
            }
        }

        return null;
    }

    /** @return bool */
    public function hasValidAnnouncement()
    {
        return (bool) $this->getNextAnnouncement();
    }
}
