import template from './new.html';

function NewUserCtrl($scope, $location, toastr, currentUser, Events, User) {
  Events.record('view', 'page', 'users/new');

  $scope.user = new User({});
  $scope.saveUser = () => {
    if (!this.userForm.$valid) {
      return;
    }

    $scope.user.$save((user) => {
      $scope.user = user;
      $scope.user.created = true;
      toastr.success('已保存');
    }, (error) => {
      const message = error.data.message || '保存失败';
      toastr.error(message);
    });
  };
}

export default function init(ngModule) {
  ngModule.controller('NewUserCtrl', NewUserCtrl);

  return {
    '/users/new': {
      template,
      controller: 'NewUserCtrl',
      controllerAs: '$ctrl',
      bindToController: 'true',
    },
  };
}
