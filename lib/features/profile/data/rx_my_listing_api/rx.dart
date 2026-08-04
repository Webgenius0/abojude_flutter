import 'dart:developer';

import 'package:abojude_flutter/features/profile/model/my_listing_model.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:abojude_flutter/networks/rx_base.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';


import 'api.dart';

final class GetMyListRx extends RxResponseInt<GetMyListingModel> {
  final GetMyListApi api = GetMyListApi.instance;

  GetMyListRx({
    required super.empty,
    required super.dataFetcher,
  });

  /// Loading state for initial load or full refresh
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  /// Loading state for pagination (lazy loading)
  final ValueNotifier<bool> isLoadingMore = ValueNotifier(false);

  int currentPage = 1;
  bool hasMoreData = true;
  List<Post> allPosts = [];

  /// Stream exposed to the UI
  Stream<GetMyListingModel> get getMyListData => dataFetcher.stream;

  /// Fetch initial listings or pull-to-refresh
  Future<GetMyListingModel> getMyList({bool isRefresh = false, int perPage = 10}) async {
    currentPage = 1;
    hasMoreData = true;
    allPosts.clear();

    isLoading.value = true;

    try {
      final data = await api.myList(page: 1, perPage: perPage);

      final newPosts = data.data?.posts ?? [];
      allPosts = List<Post>.from(newPosts);

      final pagination = data.pagination;
      if (pagination != null) {
        final lastPage = pagination.lastPage ?? 1;
        currentPage = pagination.currentPage ?? 1;
        hasMoreData = currentPage < lastPage;
      } else {
        hasMoreData = false;
      }

      final combinedModel = GetMyListingModel(
        status: data.status,
        message: data.message,
        code: data.code,
        data: Data(
          totalPost: data.data?.totalPost,
          totalView: data.data?.totalView,
          totalWish: data.data?.totalWish,
          totalMessage: data.data?.totalMessage,
          posts: allPosts,
        ),
        pagination: data.pagination,
      );

      handleSuccessWithReturn(combinedModel);
      return combinedModel;
    } catch (error) {
      handleErrorWithReturn(error);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Lazy loading (pagination) - fetch next page
  Future<void> fetchMoreData({int perPage = 10}) async {
    if (isLoadingMore.value || isLoading.value || !hasMoreData) return;

    isLoadingMore.value = true;

    try {
      final nextPage = currentPage + 1;
      final data = await api.myList(page: nextPage, perPage: perPage);

      final newPosts = data.data?.posts ?? [];
      allPosts.addAll(newPosts);

      final pagination = data.pagination;
      if (pagination != null) {
        final lastPage = pagination.lastPage ?? nextPage;
        currentPage = pagination.currentPage ?? nextPage;
        hasMoreData = currentPage < lastPage;
      } else {
        hasMoreData = false;
      }

      final currentModel = dataFetcher.hasValue ? dataFetcher.value : data;
      final combinedModel = GetMyListingModel(
        status: data.status,
        message: data.message,
        code: data.code,
        data: Data(
          totalPost: currentModel.data?.totalPost ?? data.data?.totalPost,
          totalView: currentModel.data?.totalView ?? data.data?.totalView,
          totalWish: currentModel.data?.totalWish ?? data.data?.totalWish,
          totalMessage: currentModel.data?.totalMessage ?? data.data?.totalMessage,
          posts: allPosts,
        ),
        pagination: data.pagination,
      );

      dataFetcher.sink.add(combinedModel);
    } catch (error) {
      log("Error fetching more listings: $error", name: 'GetMyListRx');
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// Delete post locally from stream
  void deletePostLocally(int postId) {
    allPosts.removeWhere((p) => p.id == postId);
    final currentModel = dataFetcher.hasValue ? dataFetcher.value : empty;

    final updatedModel = GetMyListingModel(
      status: currentModel.status,
      message: currentModel.message,
      code: currentModel.code,
      data: Data(
        totalPost: (currentModel.data?.totalPost ?? 1) > 0 ? ((currentModel.data?.totalPost ?? 1) - 1) : 0,
        totalView: currentModel.data?.totalView,
        totalWish: currentModel.data?.totalWish,
        totalMessage: currentModel.data?.totalMessage,
        posts: List<Post>.from(allPosts),
      ),
      pagination: currentModel.pagination,
    );

    dataFetcher.sink.add(updatedModel);
  }

  @override
  void handleErrorWithReturn(dynamic error) {
    if (error is DioException) {
      final responseData = error.response?.data;

      if (responseData is Map<String, dynamic>) {
        final errors = responseData['errors'];
        if (errors is Map && errors.isNotEmpty) {
          final firstError = errors.values.first;

          if (firstError is List && firstError.isNotEmpty) {
            ToastUtil.showShortToast(firstError.first.toString());
            _addError(error);
            return;
          }
        }

        final message = responseData['message'];
        if (message != null && message.toString().trim().isNotEmpty) {
          ToastUtil.showShortToast(message.toString());
          _addError(error);
          return;
        }
      }

      if (error.message?.isNotEmpty ?? false) {
        ToastUtil.showShortToast(error.message!);
      }
    } else {
      ToastUtil.showShortToast(
        "Something went wrong. Please try again.",
      );
    }

    _addError(error);
  }

  void _addError(dynamic error) {
    log(
      error.toString(),
      name: 'GetMyListRx',
    );

    dataFetcher.sink.addError(error);
  }

  @override
  void dispose() {
    isLoading.dispose();
    isLoadingMore.dispose();
    super.dispose();
  }
}