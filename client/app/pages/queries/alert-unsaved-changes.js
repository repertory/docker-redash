function alertUnsavedChanges($window) {
  return {
    restrict: 'E',
    replace: true,
    scope: {
      isDirty: '=',
    },
    link($scope) {
      const unloadMessage = '如果离开，你会丢失所有改动';
      const confirmMessage = `${unloadMessage}\n\n确实要离开这个页面吗？`;
      // store original handler (if any)
      const _onbeforeunload = $window.onbeforeunload;

      $window.onbeforeunload = function onbeforeunload() {
        return $scope.isDirty ? unloadMessage : null;
      };

      $scope.$on('$locationChangeStart', (event, next, current) => {
        if (next.split('?')[0] === current.split('?')[0] || next.split('#')[0] === current.split('#')[0]) {
          return;
        }

        if ($scope.isDirty && !$window.confirm(confirmMessage)) {
          event.preventDefault();
        }
      });

      $scope.$on('$destroy', () => {
        $window.onbeforeunload = _onbeforeunload;
      });
    },
  };
}

export default function (ngModule) {
  ngModule.directive('alertUnsavedChanges', alertUnsavedChanges);
}
