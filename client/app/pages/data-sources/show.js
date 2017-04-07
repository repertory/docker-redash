import debug from 'debug';
import template from './show.html';

const logger = debug('redash:http');

function DataSourceCtrl($scope, $routeParams, $http, $location, toastr,
  currentUser, Events, DataSource) {
  Events.record('view', 'page', 'admin/data_source');

  $scope.dataSourceId = $routeParams.dataSourceId;

  if ($scope.dataSourceId === 'new') {
    $scope.dataSource = new DataSource({ options: {} });
  } else {
    $scope.dataSource = DataSource.get({ id: $routeParams.dataSourceId });
  }

  $scope.$watch('dataSource.id', (id) => {
    if (id !== $scope.dataSourceId && id !== undefined) {
      $location.path(`/data_sources/${id}`).replace();
    }
  });

  function deleteDataSource() {
    Events.record('delete', 'datasource', $scope.dataSource.id);

    $scope.dataSource.$delete(() => {
      toastr.success('删除成功');
      $location.path('/data_sources/');
    }, (httpResponse) => {
      logger('Failed to delete data source: ', httpResponse.status, httpResponse.statusText, httpResponse.data);
      toastr.error('删除失败');
    });
  }

  function testConnection(callback) {
    Events.record('test', 'datasource', $scope.dataSource.id);

    DataSource.test({ id: $scope.dataSource.id }, (httpResponse) => {
      if (httpResponse.ok) {
        toastr.success('测试成功');
      } else {
        toastr.error(httpResponse.message, '连接测试失败:', { timeOut: 10000 });
      }
      callback();
    }, (httpResponse) => {
      logger('Failed to test data source: ', httpResponse.status, httpResponse.statusText, httpResponse);
      toastr.error('执行连接测试时出现未知错误，请稍后再试。', '连接测试失败:', { timeOut: 10000 });
      callback();
    });
  }

  $scope.actions = [
    { name: '删除', class: 'btn-danger', callback: deleteDataSource },
    { name: '测试连接', class: 'btn-default', callback: testConnection, disableWhenDirty: true },
  ];
}

export default function (ngModule) {
  ngModule.controller('DataSourceCtrl', DataSourceCtrl);

  return {
    '/data_sources/:dataSourceId': {
      template,
      controller: 'DataSourceCtrl',
      title: '数据源',
    },
  };
}
