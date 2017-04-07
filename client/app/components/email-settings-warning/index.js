function controller(clientConfig, currentUser) {
  this.showMailWarning = clientConfig.mailSettingsMissing && currentUser.isAdmin;
}

export default function (ngModule) {
  ngModule.component('emailSettingsWarning', {
    bindings: {
      function: '<',
    },
    template: '<p class="alert alert-danger" ng-if="$ctrl.showMailWarning">看起来你的邮件服务器没有配置。请确保将其配置为{{$ctrl.function}} 工作。</p>',
    controller,
  });
}
