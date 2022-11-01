import 'dart:async';
import 'dart:ffi';

import 'package:complete_advanced_flutter/data/network/failure.dart';
import 'package:complete_advanced_flutter/domain/model/model.dart';
import 'package:complete_advanced_flutter/domain/usecase/home_usecase.dart';
import 'package:complete_advanced_flutter/presentation/base/baseviewmodel.dart';
import 'package:complete_advanced_flutter/presentation/common/state_renderer/state_render_impl.dart';
import 'package:complete_advanced_flutter/presentation/common/state_renderer/state_renderer.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class HomeViewModel extends BaseViewModel
    with HomeViewModelInputs, HomeViewModelOutputs {
  HomeUseCase _homeUseCase;

  StreamController _bannerStreamController = BehaviorSubject<List<BannerAd>>();
  StreamController _serviceStreamController = BehaviorSubject<List<Service>>();
  StreamController _storesStreamController = BehaviorSubject<List<Store>>();
  HomeViewModel(this._homeUseCase);

  // inputs
  @override
  void start() {
    _getHome();
  }

  _getHome() async {
    inputState.add(
      LoadingState(
          stateRendererType: StateRendererType.FULL_SCREEN_LOADING_STATE),
    );

    (await _homeUseCase.execute(Void)).fold(
      (failure) => {
        inputState.add(ErrorState(
            StateRendererType.FULL_SCREEN_ERROR_STATE, failure.message))
      },
      (homeObject) {
        inputState.add(ContentState());
        inputBanner.add(homeObject.data.banners);
        inputService.add(homeObject.data.services);
        inputStores.add(homeObject.data.stores);
      },
    );
  }

  @override
  void dispose() {
    _bannerStreamController.close();
    _serviceStreamController.close();
    _storesStreamController.close();
    super.dispose();
  }

  @override
  Sink get inputBanner => _bannerStreamController.sink;

  @override
  Sink get inputService => _serviceStreamController.sink;

  @override
  Sink get inputStores => _storesStreamController.sink;

  //outputs
  @override
  Stream<List<BannerAd>> get outputBannerAd =>
      _bannerStreamController.stream.map((banner) => banner);

  @override
  Stream<List<Service>> get outputService =>
      _serviceStreamController.stream.map((service) => service);

  @override
  Stream<List<Store>> get outputStor =>
      _storesStreamController.stream.map((store) => store);
}

abstract class HomeViewModelInputs {
  Sink get inputStores;
  Sink get inputService;
  Sink get inputBanner;
}

abstract class HomeViewModelOutputs {
  Stream<List<Store>> get outputStor;
  Stream<List<Service>> get outputService;
  Stream<List<BannerAd>> get outputBannerAd;
}

/*
_getHome() async {
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.FULL_SCREEN_LOADING_STATE));

    (await _homeUseCase.execute(Void)).fold((failure) {
      inputState.add(ErrorState(
          StateRendererType.FULL_SCREEN_ERROR_STATE, failure.message));
    }, (homeObject) {
      inputState.add(ContentState());
      inputHomeData.add(HomeViewObject(homeObject.data.stores,
          homeObject.data.services, homeObject.data.banners));
    });
  }


  @override
  Sink get inputHomeData => _dataStreamController.sink;

  // outputs
  @override
  Stream<HomeViewObject> get outputHomeData =>
      _dataStreamController.stream.map((data) => data);
}

abstract class HomeViewModelInputs {
  Sink get inputHomeData;
}

abstract class HomeViewModelOutputs {
  Stream<HomeViewObject> get outputHomeData;
}

class HomeViewObject {
  List<Store> stores;
  List<Service> services;
  List<BannerAd> banners;

  HomeViewObject(this.stores, this.services, this.banners);
}
*/
