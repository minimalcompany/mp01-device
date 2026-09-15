# Define MGVI_MTK_ABC_SUPPORT same vaule as MTK_ABC_SUPPORT,
# and it will be used at hal layer.

FO_NEEDED_DEFINE_MGVI_LIST := MTK_VPU2_SUPPORT \
  MTK_AI_SCENE_PQ_SUPPORT \
  MTK_ULTRASND_PROXIMITY \
  MTK_RAY_TRACING_SUPPORT

$(foreach fo,$(FO_NEEDED_DEFINE_MGVI_LIST), \
  $(eval mgvi_fo := $(addprefix MGVI_,$(fo))) \
  $(if $($(mgvi_fo)),,$(eval $(mgvi_fo) := $($(fo)))) \
)
