# -*- coding: utf-8 -*-
from redash import redis_connection, models, __version__, settings


def get_status():
    status = {}
    info = redis_connection.info()
    status['Redis使用内存'] = info['used_memory_human']
    status['版本号'] = __version__
    status['查询数'] = models.db.session.query(models.Query).count()
    if settings.FEATURE_SHOW_QUERY_RESULTS_COUNT:
        status['查询结果数'] = models.db.session.query(models.QueryResult).count()
        status['未使用查询结果数'] = models.QueryResult.unused().count()
    status['仪表盘数'] = models.Dashboard.query.count()
    status['控件数'] = models.Widget.query.count()

    status['workers'] = []

    manager_status = redis_connection.hgetall('redash:status')
    status['manager'] = manager_status
    status['manager']['outdated_queries_count'] = len(models.Query.outdated_queries())

    queues = {}
    for ds in models.DataSource.query:
        for queue in (ds.queue_name, ds.scheduled_queue_name):
            queues.setdefault(queue, set())
            queues[queue].add(ds.name)

    status['manager']['queues'] = {}
    for queue, sources in queues.iteritems():
        status['manager']['queues'][queue] = {
            'data_sources': ', '.join(sources),
            'size': redis_connection.llen(queue)
        }

    return status
