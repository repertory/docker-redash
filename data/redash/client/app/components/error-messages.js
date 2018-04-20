const ErrorMessagesComponent = {
  template: `
  <div class="help-block" ng-messages="$ctrl.input.$error" ng-show="$ctrl.input.$touched || $ctrl.form.$submitted">
    <span class="error" ng-message="required">此字段是必需的。</span>
    <span class="error" ng-message="minlength">此字段太短。</span>
    <span class="error" ng-message="email">这需要一个有效的电子邮件。</span>
  </div>
  `,
  replace: true,
  bindings: {
    input: '<',
    form: '<',
  },
  controller() {
  },
};

export default function init(ngModule) {
  ngModule.component('errorMessages', ErrorMessagesComponent);
}
