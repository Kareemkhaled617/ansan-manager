import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../common/constants.dart';
import '../../../../screens/search/widgets/empty_result.dart';
import '../../models/notification_screen_model.dart';
import 'widgets/loading_widget.dart';
import 'widgets/notification_widget.dart';

class VendorAdminNotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).notifications,
          style: Theme.of(context).primaryTextTheme.headlineSmall,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Consumer<VendorAdminNotificationScreenModel>(
        builder: (context, model, _) => Stack(
          children: [
            Stack(
              children: [
                Container(
                    width: size.width,
                    height: size.height + 100,
                    color: Theme.of(context).colorScheme.surface,
                    child: LayoutBuilder(builder: (context, constraints) {
                      if (model.state ==
                          VendorAdminNotificationScreenModelState.loading) {
                        return ListView.builder(
                          itemBuilder: (context, index) =>
                              VendorAdminNotificationLoadingWidget(),
                          itemCount: 10,
                        );
                      }
                      if (model.state ==
                          VendorAdminNotificationScreenModelState.empty) {
                        return EmptyResult(
                          title: S.of(context).noData,
                        );
                      }
                      return SmartRefresher(
                        controller: model.refreshController,
                        onLoading: model.loadMoreNotification,
                        onRefresh: model.getNotification,
                        enablePullUp: true,
                        header: kClassicHeader(context),
                        footer: kCustomFooter(context),
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            if (index >= model.notifications.length &&
                                model.state ==
                                    VendorAdminNotificationScreenModelState
                                        .loadMore) {
                              return VendorAdminNotificationLoadingWidget();
                            }
                            return VendorAdminNotificationWidget(
                              notificationVendorAdmin:
                                  model.notifications[index],
                            );
                          },
                          itemCount: model.state ==
                                  VendorAdminNotificationScreenModelState
                                      .loadMore
                              ? model.notifications.length + 2
                              : model.notifications.length,
                          cacheExtent: 1000,
                        ),
                      );
                    })),
                if (model.state ==
                    VendorAdminNotificationScreenModelState.loadItem)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
