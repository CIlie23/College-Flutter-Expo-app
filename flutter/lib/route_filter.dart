import 'contract/contract.dart';

/// null means "All".
const stopFilters = <StopStatus?, String>{
  null: 'All',
  StopStatus.todo: 'To do',
  StopStatus.done: 'Done',
  StopStatus.skipped: 'Skipped',
};

/// The stops a filter keeps, in route order. A pure function: no widgets here.
List<RouteStop> filterStops(Iterable<RouteStop> stops, StopStatus? status) =>
    stops.where((s) => status == null || s.status == status).toList()
      ..sort((a, b) => a.order.compareTo(b.order));

/// What to say when the filter leaves nothing.
String emptyText(StopStatus? status) =>
    'No ${stopFilters[status]!.toLowerCase()} stops on this route.';
