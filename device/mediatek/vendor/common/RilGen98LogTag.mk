PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.mipc_lib=I
PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.trm_lib=I
# Telephony RIL log configurations
ifeq ($(strip $(MTK_TELEPHONY_CONN_LOG_CTRL_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxMclDisThread=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxCloneMgr=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxHandlerMgr=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxIdToStr=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxDisThread=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxMclStatusMgr=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RIL-Fusion=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RilOemClient=I

  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtmEccNumberController=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmEccNumberReqHdlr=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmEccNumberUrcHandler=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxBaseHandler=I

ifneq ($(strip $(TARGET_BUILD_VARIANT)),eng)
  # user/userdebug load
  # V/D/(I/W/E)
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxMclDisThread=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxCloneMgr=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxHandlerMgr=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxIdToStr=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxDisThread=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxMclStatusMgr=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RIL-Fusion=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxOpUtils=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxMclMessenger=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxFragEnc=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxStatusMgr=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxContFactory=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxChannelMgr=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxIdToMsgId=I

  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtmDC=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmDcEvent=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmDcUrcHandler=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MipcEventHandler=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.InterfaceManager=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmPhbReq=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmPhbUrc=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtmPhb=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtmIms=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtmImsConfigController=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtmImsConference=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtmImsDialog=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmImsCtlUrcHdl=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmImsCtlReqHdl=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmEmbmsReq=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmEmbmsUrc=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtmEmbmsUtil=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtmEmbmsAt=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmSimCommReq=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmSimCommUrc=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmSimBaseHandler=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtmRadioConfig=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtmCommSimCtrl=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmCommSimOpReq=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtmRadioCont=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmDcPdnManager=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmDcUtility=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmNwHdlr=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmNwReqHdlr=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmNwRTReqHdlr=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmNwAsyncHdlr=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmNwNrtReqHdlr=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmNwRatSwHdlr=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmNwUrcHdlr=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtmNwCtrl=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmRadioReq=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmCapa=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtmCapa=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtmWp=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmWp=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmOpRadioReq=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmOemHandler=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtmModeCont=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmMwi=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtmMwi=I
else
  # eng load
  # V/(D/I/W/E)
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxStatusMgr=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxFragEnc=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxContFactory=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxChannelMgr=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxMclDisThread=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxCloneMgr=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxHandlerMgr=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxOpUtils=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RfxMclMessenger=I

  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtmDC=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmDcEvent=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmDcUrcHandler=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.MipcEventHandler=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.InterfaceManager=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmEmbmsReq=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmEmbmsUrc=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtmEmbmsUtil=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtmEmbmsAt=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmRadioReq=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtmRadioCont=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmOpRadioReq=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmSimCommUrc=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtmModeCont=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmmMwi=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtmMwi=D
endif
endif


