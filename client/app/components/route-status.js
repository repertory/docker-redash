export default function (ngModule) {
  ngModule.component('routeStatus', {
    template: '<overlay ng-if="$ctrl.permissionDenied">您没有加载此页的权限。',

    controller($rootScope) {
      this.permissionDenied = false;

      $rootScope.$on('$routeChangeSuccess', () => {
        this.permissionDenied = false;
      });

      $rootScope.$on('$routeChangeError', (event, current, previous, rejection) => {
        if (rejection.status === 403) {
          this.permissionDenied = true;
        }
      });
    },
  });
}
