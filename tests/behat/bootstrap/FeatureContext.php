<?php

/**
 * @file
 * Feature context for Behat testing.
 */

use DrevOps\BehatSteps\ContentTrait;
use DrevOps\BehatSteps\FieldTrait;
use DrevOps\BehatSteps\JsTrait;
use DrevOps\BehatSteps\LinkTrait;
use DrevOps\BehatSteps\MediaTrait;
use DrevOps\BehatSteps\MenuTrait;
use DrevOps\BehatSteps\PathTrait;
use DrevOps\BehatSteps\ResponseTrait;
use DrevOps\BehatSteps\TaxonomyTrait;
use DrevOps\BehatSteps\VisibilityTrait;
use DrevOps\BehatSteps\WatchdogTrait;
use Drupal\DrupalExtension\Context\DrupalContext;

/**
 * Defines application features from the specific context.
 */
class FeatureContext extends DrupalContext {

  use LinkTrait;
  use PathTrait;
  use FieldTrait;
  use ContentTrait;
  use MediaTrait;
  use MenuTrait;
  use TaxonomyTrait;
  use ResponseTrait;
  use TideCommonTrait;
  use TideExtensionsTrait;
  use TideEntityTrait;
  use WatchdogTrait;
  use JsTrait;
  use VisibilityTrait;

}
