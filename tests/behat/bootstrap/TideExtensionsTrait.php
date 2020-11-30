<?php

use Behat\Behat\Hook\Scope\AfterFeatureScope;
use Behat\Behat\Hook\Scope\BeforeFeatureScope;
use Behat\Gherkin\Node\FeatureNode;

/**
 * Trait to handle extension dependencies of each Behat feature.
 */
trait TideExtensionsTrait {

  /**
   * List of modules installed during the test.
   *
   * @var string[]
   */
  protected static $installedModules = [];

  /**
   * Returns the module names marked for installing in a feature.
   *
   * @param \Behat\Gherkin\Node\FeatureNode $feature
   *   The test feature.
   *
   * @return string[]
   *   A list of module names marked for install.
   */
  protected static function getModulesToInstall(FeatureNode $feature): array {
    $modules = [];
    foreach ($feature->getTags() as $tag) {
      if (strpos($tag, 'install:') === 0) {
        $modules[] = substr($tag, 8);
      }
    }

    return $modules;
  }

  /**
   * Install the modules needed for this feature.
   *
   * To install a module, tag the Behat feature with the 'install' tag using
   * the following syntax: '@install:module_a @install:module_b'.
   * All dependencies must be listed so that they could be fully uninstalled
   * later.
   *
   * @param \Behat\Behat\Hook\Scope\BeforeFeatureScope $scope
   *   The feature scope.
   *
   * @BeforeFeature
   */
  public static function installModules(BeforeFeatureScope $scope): void {
    $modules = self::getModulesToInstall($scope->getFeature());
    if (!$modules) {
      return;
    }

    $module_handler = \Drupal::moduleHandler();
    /** @var \Drupal\Core\Extension\ModuleInstallerInterface $module_installer */
    $module_installer = \Drupal::service('module_installer');

    // Only install new modules.
    $modules = array_filter($modules, function ($value) use ($module_handler) {
      return !$module_handler->moduleExists($value);
    });
    $module_installer->install($modules);
    self::$installedModules = array_unique(array_merge(self::$installedModules, $modules));
    drupal_flush_all_caches();
  }

  /**
   * Uninstall modules enabled though the feature.
   *
   * @param \Behat\Behat\Hook\Scope\AfterFeatureScope $scope
   *   The feature scope.
   *
   * @AfterFeature
   */
  public static function uninstallModules(AfterFeatureScope $scope): void {
    if (!self::$installedModules) {
      return;
    }

    /** @var \Drupal\Core\Extension\ModuleInstallerInterface $module_installer */
    $module_installer = \Drupal::service('module_installer');
    $module_installer->uninstall(self::$installedModules);
    self::$installedModules = [];
  }

}
