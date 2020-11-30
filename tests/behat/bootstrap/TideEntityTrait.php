<?php

use Behat\Gherkin\Node\TableNode;

/**
 * Trait to handle custom entity creation.
 */
trait TideEntityTrait {

  /**
   * Keep track of entities so they can be cleaned up.
   *
   * @var \Drupal\Core\Entity\EntityInterface[]
   */
  protected $entities = [];

  /**
   * Creates an entity of a given type and bundle provided in the below form.
   * @code
   * | title    | author     | status | created           |
   * | My title | Joe Editor | 1      | 2014-10-17 8:00am |
   * | More     | Joe Editor | 0      | 2014-10-17 9:00am |
   * @endcode
   *
   * @Given :type :bundle entity:
   */
  public function createEntities($type, $bundle, TableNode $nodesTable) {
    foreach ($nodesTable->getHash() as $nodeHash) {
      $entity = (object) $nodeHash;
      $entity->bundle = $type;
      $this->entityCreate($entity, $type, $bundle);
    }
  }

  /**
   * Create a node.
   *
   * @return object
   *   The created node.
   */
  public function entityCreate($entity, $type, $bundle) {
    $this->parseEntityFields($type, $entity);
    $saved = $this->getDriver()->createEntity($type, $entity);
    $this->entities[$type][] = $saved;
    return $saved;
  }

  /**
   * Remove any created entities.
   *
   * @AfterScenario
   */
  public function cleanEntities() {
    // Remove any nodes that were created.
    foreach ($this->entities as $entity_type => $entities) {
      foreach ($entities as $entity) {
        $this->getDriver()->entityDelete($entity_type, $entity);
      }
    }
    $this->entities = [];
  }

}
