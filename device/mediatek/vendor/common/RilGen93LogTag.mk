PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RILMUXD=I

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

  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtcDC=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcDcCommon=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcPhbReq=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcPhbUrc=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtcPhb=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtcIms=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtcImsConfigController=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtcImsConference=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtcImsDialog=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcImsCtlUrcHdl=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcImsCtlReqHdl=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcEmbmsReq=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcEmbmsUrc=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtcEmbmsUtil=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtcEmbmsAt=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RTC_DAC=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcCommSimReq=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcCdmaSimRequest=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcGsmSimRequest=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcCommSimUrc=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcGsmSimUrc=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtcCommSimCtrl=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcCommSimOpReq=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtcRadioCont=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcDcPdnManager=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcDcReqHandler=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcDcUtility=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcNwHdlr=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcNwReqHdlr=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcNwRTReqHdlr=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcRatSwHdlr=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtcRatSwCtrl=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtcNwCtrl=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcRadioReq=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcCapa=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtcCapa=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtcWp=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcWp=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcOpRadioReq=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcCdmaSimUrc=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcOemHandler=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtcModeCont=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtcEccNumberController=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcEccNumberUrcHandler=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.EccNumberPreference=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.EccNumberSource=I
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

  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtcDC=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcDcCommon=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RTC_DAC=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcEmbmsReq=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcEmbmsUrc=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtcEmbmsUtil=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtcEmbmsAt=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcRadioReq=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtcRadioCont=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcOpRadioReq=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcCdmaSimUrc=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtcModeCont=I
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RtcEccNumberController=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.RmcEccNumberUrcHandler=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.EccNumberPreference=D
  PRODUCT_PROPERTY_OVERRIDES += persist.log.tag.EccNumberSource=D
endif
endif

