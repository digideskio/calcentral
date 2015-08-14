'use strict';

var _ = require('lodash');
var angular = require('angular');

/**
 * Profile controller
 */
angular.module('calcentral.controllers').controller('ProfileController', function(apiService, $routeParams, $scope) {
  var navigation = [{
    'label': 'Profile',
    'categories': [{
      'id': 'basic',
      'name': 'Basic Information'
    },{
      'id': 'contact',
      'name': 'Contact Information'
    },{
      'id': 'academic',
      'name': 'Academic Information'
    }]
  },
  {
    'label': 'Alerts & Notifications',
    'categories': [{
      'id': 'bconnected',
      'name': 'bConnected'
    }]
  }];

  /**
   * Use lodash to match category ID
   */
  var matchId = function(categories, id) {
    return _.find(categories, function(category) {
      return category.id === id;
    });
  };

  /**
   * Find the category object when we get a categoryId back
   */
  var findCategory = function(categoryId) {
    for (var i = 0; i < navigation.length; i++) {
      var selectedCategory = matchId(navigation[i].categories, categoryId);
      if (selectedCategory) {
        return selectedCategory;
      }
    }
  };

  /**
   * Get the category depending on the routeParam
   */
  var getCurrentCategory = function() {
    if ($routeParams.category) {
      return findCategory($routeParams.category);
    } else {
      return navigation[0].categories[0];
    }
  };

  /**
   * Set the page title
   */
  var setPageTitle = function() {
    var title = $scope.header + ' - ' + $scope.currentCategory.name;
    apiService.util.setTitle(title);
  };

  var init = function() {
    var currentCategory = getCurrentCategory();

    // If no category was found, redirect to the 404 page
    if (!currentCategory) {
      apiService.util.redirect('404');
      return false;
    }

    $scope.header = navigation[0].label;
    $scope.currentCategory = currentCategory;
    $scope.navigation = navigation;

    setPageTitle();
  };

  init();
});
