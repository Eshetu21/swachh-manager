import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kabadmanager/core/extensions/string_extension.dart';
import 'package:kabadmanager/features/auth/providers/auth_controller.dart';
import 'package:kabadmanager/features/home/providers/home_page_controller.dart';
import 'package:kabadmanager/features/home/screens/assign_request_popup.dart';
import 'package:kabadmanager/features/home/screens/request_preview_page.dart';
import 'package:kabadmanager/models/pickup_request_model.dart';
import 'package:kabadmanager/shimmering_widgets/request_tile.dart';
import 'package:kabadmanager/widgets/request_items_bottomsheet.dart';
import 'package:kabadmanager/widgets/request_tile.dart';
import 'package:kabadmanager/widgets/text_widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final categoryProvider = StateProvider((ref) {
  final statuses = getStatusListAsPerRole(ref);
  return statuses[0];
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

List<RequestStatus> getStatusListAsPerRole(dynamic ref) {
  final isPartnerAsyncVal = ref.read(isDeliveryPartnerProvider);
  final isAdminAsyncVal = ref.read(isAdminProvider);
  if (isPartnerAsyncVal.hasValue && isPartnerAsyncVal.value == true) {
    return [
      RequestStatus.accepted,
      RequestStatus.onTheWay,
      RequestStatus.picked
    ];
  }
  if (isAdminAsyncVal.hasValue && isAdminAsyncVal.value == true) {
    return [
      RequestStatus.requested,
      RequestStatus.accepted,
      RequestStatus.onTheWay,
      RequestStatus.picked,
      RequestStatus.denied
    ];
  }
  return [];
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homePageControllerProvider);
    final controller = ref.read(homePageControllerProvider.notifier);
    final appUser = Supabase.instance.client.auth.currentUser;
    final category = ref.watch(categoryProvider);
    final statuses = getStatusListAsPerRole(ref);
    return Scaffold(
        appBar: AppBar(
          title: const TitleLarge(
            text: 'KabadManager',
            weight: FontWeight.bold,
          ),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                  accountName: const Text(""),
                  accountEmail: Text('${appUser?.email}')),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const LabelLarge(text: 'LogOut'),
                onTap: () {
                  ref.read(authControllerProvider).signOut();
                },
              ),
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            controller.getRequestsByStatus(category);
          },
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: false,
                floating: true,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(20),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: statuses.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: ChoiceChip(
                                  label: Text(
                                    statuses[index].name.capitalize,
                                  ),
                                  selected: category == statuses[index],
                                  onSelected: (selected) {
                                    ref
                                        .read(categoryProvider.notifier)
                                        .update((state) => statuses[index]);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              Builder(
                builder: (context) {
                  return state.when(loading: () {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((ctx, index) {
                        return const ShimmeringPickRequestTile();
                      }, childCount: 16),
                    );
                  }, data: (data) {
                    if (data.isEmpty) {
                      return const SliverFillRemaining(
                        child: Center(child: Text("Empty")),
                      );
                    }
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((ctx, index) {
                        final model = data[index];
                        if (model.status == RequestStatus.requested) {
                          return Slidable(
                              // Specify a key if the Slidable is dismissible.
                              key: ValueKey(model.id),

                              // The start action pane is the one at the left or the top side.
                              startActionPane: ActionPane(
                                // A motion is a widget used to control how the pane animates.
                                motion: const ScrollMotion(),

                                // A pane can dismiss the Slidable.
                                dismissible: DismissiblePane(onDismissed: () {
                                  controller.updateStatus(
                                      id: model.id,
                                      newStatus: RequestStatus.denied);
                                }),

                                // All actions are defined in the children parameter.
                                children: [
                                  // A SlidableAction can have an icon and/or a label.
                                  SlidableAction(
                                    onPressed: (c) {
                                      controller.updateStatus(
                                          id: model.id,
                                          newStatus: RequestStatus.denied);
                                    },
                                    backgroundColor: const Color(0xFFFE4A49),
                                    foregroundColor: Colors.white,
                                    icon: Icons.close_outlined,
                                    label: 'Denied',
                                  ),
                                ],
                              ),

                              // The end action pane is the one at the right or the bottom side.
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    flex: 2,
                                    onPressed: (c) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AssignPartnerPopup(
                                            requestId: model.id,
                                          );
                                        },
                                      );
                                    },
                                    backgroundColor: Colors.greenAccent,
                                    foregroundColor: Colors.white,
                                    icon: Icons.check_circle_outline_outlined,
                                    label: 'Accept',
                                  ),
                                ],
                              ),
                              child: PickRequestTile(
                                  onLongTap: () {
                                    showRequestContentsBottomSheet(ctx,
                                        requestModel: data[index]);
                                  },
                                  onTap: (model) {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (cx) {
                                      return RequestPreviewPage(model);
                                    }));
                                  },
                                  model: data[index]));
                        }
                        return PickRequestTile(
                            onLongTap: () {
                              showRequestContentsBottomSheet(ctx,
                                  requestModel: data[index]);
                            },
                            onTap: (model) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (cx) {
                                return RequestPreviewPage(model);
                              }));
                            },
                            model: data[index]);
                      }, childCount: data.length),
                    );
                  }, error: (e) {
                    return SliverToBoxAdapter(
                      child: Text('Error ${e.toString()}'),
                    );
                  }, networkError: () {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((ctx, index) {
                        return const ShimmeringPickRequestTile();
                      }, childCount: 16),
                    );
                  });
                },
              )
            ],
          ),
        ));
  }
}
