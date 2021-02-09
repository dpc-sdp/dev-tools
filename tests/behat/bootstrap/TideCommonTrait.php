<?php

/**
 * Common test trait for Tide.
 *
 * @todo Review this trait and try using BehatSteps trait instead.
 */
trait TideCommonTrait {

  /**
   * @Then I am in the :path path
   */
  public function assertCurrentPath($path) {
    $current_path = $this->getSession()->getCurrentUrl();
    $current_path = parse_url($current_path, PHP_URL_PATH);
    $current_path = ltrim($current_path, '/');
    $current_path = $current_path == '' ? '<front>' : $current_path;

    if ($current_path != $path) {
      throw new \Exception(sprintf('Current path is "%s", but expected is "%s"', $current_path, $path));
    }
  }

  /**
   * Creates and authenticates a user with the given role(s).
   *
   * @Given I am logged in as a user with the :role role(s)
   * @Given I am logged in as a/an :role
   */
  public function assertAuthenticatedByRole($role) {
    // Override parent assertion to allow using 'anonymous user' role without
    // actually creating a user with role. By default,
    // assertAuthenticatedByRole() will create a user with 'authenticated role'
    // even if 'anonymous user' role is provided.
    if ($role === 'anonymous user') {
      if (!empty($this->loggedInUser)) {
        $this->logout();
      }
    }
    else {
      parent::assertAuthenticatedByRole($role);
    }
  }

  /**
   * @Then I wait for :sec second(s)
   */
  public function waitForSeconds($sec) {
    sleep($sec);
  }

  /**
   * Wait for AJAX to finish.
   *
   * @see \Drupal\FunctionalJavascriptTests\JSWebAssert::assertWaitOnAjaxRequest()
   *
   * @Given I wait :timeout seconds for AJAX to finish
   */
  public function iWaitForAjaxToFinish($timeout) {
    $condition = <<<JS
      (function() {
        function isAjaxing(instance) {
          return instance && instance.ajaxing === true;
        }
        return (
          // Assert no AJAX request is running (via jQuery or Drupal) and no
          // animation is running.
          (typeof jQuery === 'undefined' || (jQuery.active === 0 && jQuery(':animated').length === 0)) &&
          (typeof Drupal === 'undefined' || typeof Drupal.ajax === 'undefined' || !Drupal.ajax.instances.some(isAjaxing))
        );
      }());
JS;
    $result = $this->getSession()->wait($timeout * 1000, $condition);
    if (!$result) {
      throw new \RuntimeException('Unable to complete AJAX request.');
    }
  }

  /**
   * @Given no :type content type
   */
  public function removeContentType($type) {
    $content_type_entity = \Drupal::entityTypeManager()->getStorage('node_type')->load($type);
    if ($content_type_entity) {
      $content_type_entity->delete();
    }
  }

  /**
   * @When I scroll :selector into view
   * @When I scroll selector :selector into view
   *
   * @param string $selector
   *   Allowed selectors: #id, .className, //xpath.
   *
   * @throws \Exception
   */
  public function scrollIntoView($selector) {
    $function = <<<JS
      (function() {
        jQuery("$selector").get(0).scrollIntoView(false);
      }());
JS;
    try {
      $this->getSession()->executeScript($function);
    }
    catch (Exception $e) {
      throw new \Exception(__METHOD__ . ' failed');
    }
  }

  /**
   * @Then /^I click on link with href "([^"]*)"$/
   * @Then /^I click on link with href value "([^"]*)"$/
   *
   * @param string $href
   *   The href value.
   */
  public function clickOnLinkWithHref(string $href) {
    $page = $this->getSession()->getPage();
    $link = $page->find('xpath', '//a[@href="' . $href . '"]');
    if ($link === NULL) {
      throw new \Exception('Link with href "' . $href . '" not found.');
    }
    $link->click();
  }

  /**
   * @Then /^I click on the horizontal tab "([^"]*)"$/
   * @Then /^I click on the horizontal tab with text "([^"]*)"$/
   *
   * @param string $text
   *   The text.
   */
  public function clickOnHorzTab(string $text) {
    $page = $this->getSession()->getPage();
    $link = $page->find('xpath', '//ul[contains(@class, "horizontal-tabs-list")]/li[contains(@class, "horizontal-tab-button")]/a/strong[text()="' . $text . '"]');
    if ($link === NULL) {
      throw new \Exception('The horizontal tab with text "' . $text . '" not found.');
    }
    $link->click();
  }

  /**
   * @Then /^I click on the detail "([^"]*)"$/
   * @Then /^I click on the detail with text "([^"]*)"$/
   *
   * @param string $text
   *   The text.
   */
  public function clickOnDetail(string $text) {
    $page = $this->getSession()->getPage();
    $link = $page->find('xpath', '//div[contains(@class, "details-wrapper")]/details/summary[text()="' . $text . '"]');
    if ($link === NULL) {
      $link = $page->find('xpath', '//div[contains(@class, "details-wrapper")]/details/summary/span[text()="' . $text . '"]');
      if ($link === NULL) {
        throw new \Exception('The detail with text "' . $text . '" not found.');
      }
    }
    $link->click();
  }

}
