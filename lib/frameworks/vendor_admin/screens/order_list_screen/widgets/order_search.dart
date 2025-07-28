import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:provider/provider.dart';

import '../../../../../models/order/order.dart';
import '../../../config/theme.dart';
import '../order_list_screen_model.dart';

class VendorAdminOrderSearch extends StatelessWidget {
  final Function? updateOrdersInHomeScreen;
  final TextEditingController controller;
  final TextEditingController nameController;
  final Function? onSearchOrder;

  const VendorAdminOrderSearch({
    super.key,
    this.updateOrdersInHomeScreen,
    required this.controller,
    required this.nameController,
    this.onSearchOrder,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Theme.of(context).colorScheme.secondary,
        );

    void getOrders(ctx, VendorAdminOrderListScreenModel model, status) {
      model.updateStatusOption(status);
      if (model.searchController.text != '' ||
          model.nameSearchController.text != '') {
        model.searchVendorOrders();
      } else {
        model.getVendorOrders();
      }

      Navigator.of(ctx).pop();
    }

    void showFilterOptions(VendorAdminOrderListScreenModel model) {
      showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (subContext) => CupertinoActionSheet(
                actions: [
                  CupertinoActionSheetAction(
                      onPressed: () {
                        model.updateStatusOption(null);
                        if (model.searchController.text != '' ||
                            model.nameSearchController.text != '') {
                          model.searchVendorOrders();
                        } else {
                          model.getVendorOrders().then((value) =>
                              updateOrdersInHomeScreen!(list: model.orders));
                        }
                        Navigator.of(subContext).pop();
                      },
                      child: Text(S.of(subContext).all, style: textStyle)),
                  CupertinoActionSheetAction(
                      onPressed: () =>
                          getOrders(subContext, model, OrderStatus.onHold),
                      child: Text(
                        S.of(subContext).orderStatusOnHold,
                        style: textStyle,
                      )),
                  CupertinoActionSheetAction(
                      onPressed: () =>
                          getOrders(subContext, model, OrderStatus.pending),
                      child: Text(
                        S.of(subContext).orderStatusPending,
                        style: textStyle,
                      )),
                  CupertinoActionSheetAction(
                      onPressed: () =>
                          getOrders(subContext, model, OrderStatus.refunded),
                      child: Text(
                        S.of(subContext).orderStatusRefunded,
                        style: textStyle,
                      )),
                  CupertinoActionSheetAction(
                      onPressed: () =>
                          getOrders(subContext, model, OrderStatus.completed),
                      child: Text(
                        S.of(subContext).orderStatusCompleted,
                        style: textStyle,
                      )),
                  CupertinoActionSheetAction(
                      onPressed: () =>
                          getOrders(subContext, model, OrderStatus.processing),
                      child: Text(
                        S.of(subContext).orderStatusProcessing,
                        style: textStyle,
                      )),
                ],
                cancelButton: CupertinoActionSheetAction(
                  onPressed: () => Navigator.of(subContext).pop(),
                  isDefaultAction: true,
                  child: Text(
                    S.of(context).cancel,
                    style: textStyle.apply(color: Colors.red),
                  ),
                ),
              ));
    }

    void showSearchOptions(VendorAdminOrderListScreenModel model) {
      showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (subContext) => CupertinoActionSheet(
                actions: [
                  CupertinoActionSheetAction(
                      onPressed: () {
                        final isUpdated =
                            model.updateSearchOption(SearchOption.orderId);
                        final isControllerEmpty =
                            (model.searchController.text == '' &&
                                model.nameSearchController.text == '');

                        if (isUpdated) {
                          if (isControllerEmpty) {
                            model.getVendorOrders();
                          } else {
                            onSearchOrder?.call();
                          }
                        }
                        Navigator.of(subContext).pop();
                      },
                      child: Text(
                        S.of(subContext).orderIdWithoutColon,
                        style: textStyle,
                      )),
                  CupertinoActionSheetAction(
                      onPressed: () {
                        final isUpdated =
                            model.updateSearchOption(SearchOption.name);
                        final isControllerEmpty =
                            (model.searchController.text == '' &&
                                model.nameSearchController.text == '');
                        if (isUpdated) {
                          if (isControllerEmpty) {
                            model.getVendorOrders();
                          } else {
                            onSearchOrder?.call();
                          }
                        }
                        Navigator.of(subContext).pop();
                      },
                      child: Text(
                        S.of(subContext).name,
                        style: textStyle,
                      )),
                ],
                cancelButton: CupertinoActionSheetAction(
                  onPressed: () => Navigator.of(subContext).pop(),
                  isDefaultAction: true,
                  child: Text(
                    S.of(subContext).cancel,
                    style: textStyle.apply(color: Colors.red),
                  ),
                ),
              ));
    }

    return Consumer<VendorAdminOrderListScreenModel>(
      builder: (context, model, _) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Column(
          children: [
            InkWell(
              onTap: () => showFilterOptions(model),
              child: Container(
                decoration: BoxDecoration(
                  color: ColorsConfig.searchBackgroundColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        model.status?.getTranslation(context) ??
                            S.of(context).filter.toUpperCase(),
                        style: textStyle.apply(color: Colors.white),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Tools.isRTL(context)
                            ? const Border(
                                right:
                                    BorderSide(color: Colors.white, width: 0.5),
                              )
                            : const Border(
                                left:
                                    BorderSide(color: Colors.white, width: 0.5),
                              ),
                      ),
                      child: const Icon(Icons.keyboard_arrow_down_rounded,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 5.0,
                vertical: 1.0,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(20.0),
                color: ColorsConfig.searchBackgroundColor,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.start,
                      controller: controller,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (val) => onSearchOrder!(),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        isDense: true,
                        fillColor: ColorsConfig.searchBackgroundColor,
                        hintText: model.searchOption == SearchOption.name
                            ? S.of(context).searchByName
                            : S.of(context).searchOrderId,
                        hintStyle: textStyle.apply(color: Colors.white),
                      ),
                      style: textStyle.apply(color: Colors.white),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  InkWell(
                    onTap: () => showSearchOptions(model),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Tools.isRTL(context)
                              ? const Border(
                                  right: BorderSide(
                                      color: Colors.white, width: 0.5),
                                )
                              : const Border(
                                  left: BorderSide(
                                      color: Colors.white, width: 0.5),
                                )),
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
