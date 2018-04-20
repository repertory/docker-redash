function controller(clientConfig, currentUser) {
  this.showMailWarning = clientConfig.mailSettingsMissing && currentUser.isAdmin;
}

export default function init(ngModule) {
  ngModule.component('emailSettingsWarning', {
    bindings: {
      function: '<',
    },
    template: '<p class="alert alert-danger" ng-if="$ctrl.showMailWarning">它看起来像您的邮件服务器没有配置。请确保为 {{$ctrl.function}} 才能正常工作。</p>',
    controller,
  });
}
