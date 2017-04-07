import { contains, without, compact } from 'underscore';
import template from './alert-subscriptions.html';

function controller($scope, $q, $sce, currentUser, AlertSubscription, Destination, toastr) {
  'ngInject';

  $scope.newSubscription = {};
  $scope.subscribers = [];
  $scope.destinations = [];
  $scope.currentUser = currentUser;

  $q.all([Destination.query().$promise,
    AlertSubscription.query({ alertId: $scope.alertId }).$promise]).then((responses) => {
      const destinations = responses[0];
      const subscribers = responses[1];

      const subscribedDestinations =
        compact(subscribers.map(s => s.destination && s.destination.id));

      const subscribedUsers =
        compact(subscribers.map(s => !s.destination && s.user.id));

      $scope.destinations = destinations.filter(d => !contains(subscribedDestinations, d.id));

      if (!contains(subscribedUsers, currentUser.id)) {
        $scope.destinations.unshift({ user: { name: currentUser.name } });
      }

      $scope.newSubscription.destination = $scope.destinations[0];
      $scope.subscribers = subscribers;
    });

  $scope.destinationsDisplay = (d) => {
    if (!d) {
      return '';
    }

    let destination = d;
    if (d.destination) {
      destination = destination.destination;
    } else if (destination.user) {
      destination = {
        name: `${d.user.name} (Email)`,
        icon: 'fa-envelope',
        type: 'user',
      };
    }

    return $sce.trustAsHtml(`<i class="fa ${destination.icon}"></i>&nbsp;${destination.name}`);
  };

  $scope.saveSubscriber = () => {
    const sub = new AlertSubscription({ alert_id: $scope.alertId });
    if ($scope.newSubscription.destination.id) {
      sub.destination_id = $scope.newSubscription.destination.id;
    }

    sub.$save(() => {
      toastr.success('订阅成功');
      $scope.subscribers.push(sub);
      $scope.destinations = without($scope.destinations, $scope.newSubscription.destination);
      if ($scope.destinations.length > 0) {
        $scope.newSubscription.destination = $scope.destinations[0];
      } else {
        $scope.newSubscription.destination = undefined;
      }
    }, () => {
      toastr.error('订阅失败');
    });
  };

  $scope.unsubscribe = (subscriber) => {
    const destination = subscriber.destination;
    const user = subscriber.user;

    subscriber.$delete(() => {
      toastr.success('退订成功');
      $scope.subscribers = without($scope.subscribers, subscriber);
      if (destination) {
        $scope.destinations.push(destination);
      } else if (user.id === currentUser.id) {
        $scope.destinations.push({ user: { name: currentUser.name } });
      }

      if ($scope.destinations.length === 1) {
        $scope.newSubscription.destination = $scope.destinations[0];
      }
    }, () => {
      toastr.error('退订失败');
    });
  };
}

export default () => ({
  restrict: 'E',
  replace: true,
  scope: {
    alertId: '=',
  },
  template,
  controller,
});
