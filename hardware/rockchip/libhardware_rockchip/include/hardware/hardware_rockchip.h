#ifndef LIBHARDWARE_HARDWARE_ROCKCHIP_H
#define LIBHARDWARE_HARDWARE_ROCKCHIP_H

__BEGIN_DECLS

#define HWC_BLENDING_DIM            0x0805
#define HWC_BLENDING_CLEAR_HOLE     0x0806
#define HWC_Layer_DEBUG
#define LayerNameLength             60

enum {
    HWC_TOWIN0 = 6,
    HWC_TOWIN1 = 7,
    HWC_LCDC = 8,
    HWC_NODRAW = 9,
    HWC_MIX = 10,
    HWC_MIX_V2 = 11
};

typedef enum {

    /*
     * sRGB color pixel formats:
     *
     * The red, green and blue components are stored in sRGB space, and converted
     * to linear space when read, using the standard sRGB to linear equation:
     *
     * Clinear = Csrgb / 12.92                  for Csrgb <= 0.04045
     *         = (Csrgb + 0.055 / 1.055)^2.4    for Csrgb >  0.04045
     *
     * When written the inverse transformation is performed:
     *
     * Csrgb = 12.92 * Clinear                  for Clinear <= 0.0031308
     *       = 1.055 * Clinear^(1/2.4) - 0.055  for Clinear >  0.0031308
     *
     *
     *  The alpha component, if present, is always stored in linear space and
     *  is left unmodified when read or written.
     *
     */
    HAL_PIXEL_FORMAT_sRGB_A_8888        = 0xC,
    HAL_PIXEL_FORMAT_sRGB_X_8888        = 0xD,

    HAL_PIXEL_FORMAT_YCrCb_NV12         = 0x15, // YUY2
    HAL_PIXEL_FORMAT_YCrCb_NV12_VIDEO   = 0x16,
    HAL_PIXEL_FORMAT_YCrCb_NV12_10      = 0x17, // YUY2_1obit
    HAL_PIXEL_FORMAT_YCbCr_422_SP_10    = 0x18, //
    HAL_PIXEL_FORMAT_YCrCb_420_SP_10    = 0x19, //

    HAL_PIXEL_FORMAT_YUV420_8BIT_I      = 0x1A, // 420I 8bit
    HAL_PIXEL_FORMAT_YUV420_10BIT_I     = 0x1B, // 420I 10bit
    HAL_PIXEL_FORMAT_Y210               = 0x1C, // 422I 10bit

    HAL_PIXEL_FORMAT_BPP_1              = 0x30,
    HAL_PIXEL_FORMAT_BPP_2              = 0x31,
    HAL_PIXEL_FORMAT_BPP_4              = 0x32,
    HAL_PIXEL_FORMAT_BPP_8              = 0x33,
} rk_pixel_format_t;

__END_DECLS
#endif // LIBHARDWARE_HARDWARE_ROCKCHIP_H
