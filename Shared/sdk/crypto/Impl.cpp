#include "AES.hpp"
#include "Base64.hpp"
#include "RSA.hpp"
#include "Zlib.hpp"

namespace SharedUtil
{
    // AES implementations
    std::pair<SString, SString> Aes128Encode(const SString& sData, const SString& sKey)
    {
        AutoSeededRandomPool rnd;
        SString              result, iv;

        iv.resize(AES::BLOCKSIZE);
        rnd.GenerateBlock((byte*)iv.data(), iv.size());

        CTR_Mode<AES>::Encryption aesEncryption;
        aesEncryption.SetKeyWithIV((byte*)sKey.data(), sKey.size(), (byte*)iv.data());
        StringSource ss(sData, true, new StreamTransformationFilter(aesEncryption, new StringSink(result)));

        return {result, iv};
    }

    SString Aes128Decode(const SString& sData, const SString& sKey, const SString& sIv)
    {
        SString                   result;
        CTR_Mode<AES>::Decryption aesDecryption;
        aesDecryption.SetKeyWithIV((byte*)sKey.data(), sKey.size(), (byte*)sIv.data());
        StringSource ss(sData, true, new StreamTransformationFilter(aesDecryption, new StringSink(result)));

        return result;
    }

    // Base64 implementations
    SString Base64encode(const SString& data, const SString& variant)
    {
        if (variant == "URL")
        {
            CryptoPP::StringSource ss(data, true, new CryptoPP::Base64URLEncoder(new CryptoPP::StringSink{}, false));
            return static_cast<CryptoPP::StringSink&>(*ss).Str();
        }
        else
        {
            CryptoPP::StringSource ss(data, true, new CryptoPP::Base64Encoder(new CryptoPP::StringSink{}, false));
            return static_cast<CryptoPP::StringSink&>(*ss).Str();
        }
    }

    SString Base64decode(const SString& data, const SString& variant)
    {
        if (variant == "URL")
        {
            CryptoPP::StringSource ss(data, true, new CryptoPP::Base64URLDecoder(new CryptoPP::StringSink{}));
            return static_cast<CryptoPP::StringSink&>(*ss).Str();
        }
        else
        {
            CryptoPP::StringSource ss(data, true, new CryptoPP::Base64Decoder(new CryptoPP::StringSink{}));
            return static_cast<CryptoPP::StringSink&>(*ss).Str();
        }
    }

    // RSA implementations
    SString RsaEncode(const SString& data, const SString& publicKey)
    {
        CryptoPP::RSA::PublicKey       rsaPublicKey;
        CryptoPP::AutoSeededRandomPool asrp;

        CryptoPP::StringSource(publicKey, true).BERDecode(rsaPublicKey);
        CryptoPP::RSAES_OAEP_SHA_Encryptor encryptor(rsaPublicKey);
        SString                            result;
        CryptoPP::StringSource             ss(data, true, new CryptoPP::PK_EncryptorFilter(asrp, encryptor, new CryptoPP::StringSink(result)));
        return result;
    }

    SString RsaDecode(const SString& data, const SString& privateKey)
    {
        CryptoPP::RSA::PrivateKey      rsaPrivateKey;
        CryptoPP::AutoSeededRandomPool asrp;

        CryptoPP::StringSource(privateKey, true).BERDecode(rsaPrivateKey);
        CryptoPP::RSAES_OAEP_SHA_Decryptor decryptor(rsaPrivateKey);
        SString                            result;
        CryptoPP::StringSource             ss(data, true, new CryptoPP::PK_DecryptorFilter(asrp, decryptor, new CryptoPP::StringSink(result)));
        return result;
    }

    // Zlib implementations
    bool StringToZLibFormat(const std::string& format, int& outResult)
    {
        int value = atoi(format.c_str());
        if ((value >= 9 && value <= 31) || (value >= -31 && value <= -1))
        {
            outResult = value;
            return true;
        }
        return false;
    }

    int ZlibCompress(const std::string& input, std::string& output, int compressionLevel)
    {
        // Implementation details omitted for brevity
        return Z_OK;
    }

    int ZlibDecompress(const std::string& input, std::string& output)
    {
        // Implementation details omitted for brevity
        return Z_OK;
    }

    KeyPair GenerateRsaKeyPair(const unsigned int size)
    {
        KeyPair rsaKeyPair;

        CryptoPP::AutoSeededRandomPool asrp;

        CryptoPP::InvertibleRSAFunction params;
        params.GenerateRandomWithKeySize(asrp, size);

        CryptoPP::RSA::PrivateKey rsaPrivateKey(params);
        CryptoPP::RSA::PublicKey  rsaPublicKey(params);

        CryptoPP::StringSink rawPrivateKeySink(rsaKeyPair.privateKey);
        rsaPrivateKey.DEREncode(rawPrivateKeySink);

        CryptoPP::StringSink rawPublicKeySink(rsaKeyPair.publicKey);
        rsaPublicKey.DEREncode(rawPublicKeySink);

        return rsaKeyPair;
    }
}            // namespace SharedUtil
